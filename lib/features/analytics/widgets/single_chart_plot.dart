import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/analytics/data/chart_point.dart';

enum ChartColor { red, green }

enum TimeInterval { day, week, month, threeMonths, ytd, year, all }

class SingleChartPlot extends StatefulWidget {
  final List<ChartPoint> dataPoints;
  final ChartColor chartColor;
  final String valuePrefix;
  final double height;

  const SingleChartPlot({
    super.key,
    required this.dataPoints,
    this.chartColor = ChartColor.red,
    this.valuePrefix = '',
    this.height = 300,
  });

  @override
  SingleChartPlotState createState() => SingleChartPlotState();
}

class SingleChartPlotState extends State<SingleChartPlot> with SingleTickerProviderStateMixin {
  ChartPoint? selectedPoint;
  Offset? tooltipPosition;
  late AnimationController _animationController;
  late Animation<double> _animation;
  TimeInterval _selectedInterval = TimeInterval.threeMonths;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get chartColor {
    return widget.chartColor == ChartColor.red
        ? const Color(0xFFE53935)
        : GlobalVariables.secondaryColor;
  }

  List<ChartPoint> get visiblePoints {
    if (widget.dataPoints.isEmpty) {
      return List.generate(7, (index) {
        final date = DateTime.now().subtract(Duration(days: 6 - index));
        return ChartPoint(date, 0);
      });
    }

    final now = DateTime.now();
    final filteredPoints = _filterPointsByInterval(now);
    
    if (filteredPoints.isEmpty) {
      return List.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return ChartPoint(date, 0);
      });
    }
    
    return filteredPoints;
  }

  List<ChartPoint> _filterPointsByInterval(DateTime now) {
    if (widget.dataPoints.isEmpty) return [];
    
    final List<ChartPoint> sortedPoints = List.from(widget.dataPoints)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    switch (_selectedInterval) {
      case TimeInterval.day:
        // Only show data points from the current day (midnight to now)
        final startOfDay = DateTime(now.year, now.month, now.day);
        return sortedPoints.where((point) => 
          point.date.isAfter(startOfDay) || 
          (point.date.year == startOfDay.year && 
           point.date.month == startOfDay.month && 
           point.date.day == startOfDay.day)).toList();
      case TimeInterval.week:
        return sortedPoints.where((point) => 
          point.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
      case TimeInterval.month:
        return sortedPoints.where((point) => 
          point.date.isAfter(DateTime(now.year, now.month - 1, now.day))).toList();
      case TimeInterval.threeMonths:
        return sortedPoints.where((point) => 
          point.date.isAfter(DateTime(now.year, now.month - 3, now.day))).toList();
      case TimeInterval.ytd:
        return sortedPoints.where((point) => 
          point.date.isAfter(DateTime(now.year, 1, 1))).toList();
      case TimeInterval.year:
        return sortedPoints.where((point) => 
          point.date.isAfter(DateTime(now.year - 1, now.month, now.day))).toList();
      case TimeInterval.all:
        return sortedPoints;
    }
  }

  double get intervalTotal {
    return visiblePoints.fold(0, (sum, point) => sum + point.value);
  }

  void _setTimeInterval(TimeInterval interval) {
    if (_selectedInterval != interval) {
      setState(() {
        _selectedInterval = interval;
      });
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: _buildIntervalTotal(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: GestureDetector(
                    onPanDown: (details) => _updateTooltip(details.localPosition),
                    onPanUpdate: (details) => _updateTooltip(details.localPosition),
                    onPanEnd: (_) => _hideTooltip(),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: LineChartPainter(
                            dataPoints: visiblePoints,
                            color: chartColor,
                            selectedPoint: selectedPoint,
                            animation: _animation,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (selectedPoint != null && tooltipPosition != null)
                  Positioned(
                    left: tooltipPosition!.dx - 50,
                    top: tooltipPosition!.dy - 45,
                    child: _buildTooltip(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildTimeIntervalSelector(),
        ],
      ),
    );
  }

  Widget _buildIntervalTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 24),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: intervalTotal),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Text(
            '${widget.valuePrefix}${NumberFormat('#,##0').format(value)}',
            style: TextStyle(
              color: widget.chartColor == ChartColor.green 
                ? GlobalVariables.secondaryColor
                : const Color(0xFFE53935),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeIntervalSelector() {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIntervalButton(TimeInterval.day, '1D'),
          _buildIntervalButton(TimeInterval.week, '1W'),
          _buildIntervalButton(TimeInterval.month, '1M'),
          _buildIntervalButton(TimeInterval.threeMonths, '3M'),
          _buildIntervalButton(TimeInterval.ytd, 'YTD'),
          _buildIntervalButton(TimeInterval.year, '1Y'),
          _buildIntervalButton(TimeInterval.all, 'ALL'),
        ],
      ),
    );
  }

  Widget _buildIntervalButton(TimeInterval interval, String label) {
    final isSelected = _selectedInterval == interval;
    
    return GestureDetector(
      onTap: () => _setTimeInterval(interval),
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? GlobalVariables.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white.withAlpha((0.7 * 255).toInt()),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.7 * 255).toInt()),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTooltipDate(selectedPoint!.date),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rupiahFormatCurrency(selectedPoint!.value.toInt()),
            style: TextStyle(
              color: widget.chartColor == ChartColor.green
                  ? GlobalVariables.secondaryColor
                  : const Color(0xFFE53935),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Format date based on selected interval
  String _formatTooltipDate(DateTime date) {
    switch (_selectedInterval) {
      case TimeInterval.day:
        return DateFormat('h:mm a').format(date); // AM/PM format for 1D view
      case TimeInterval.week:
        return DateFormat('EEE, MMM d').format(date);
      case TimeInterval.month:
      case TimeInterval.threeMonths:
      case TimeInterval.ytd:
      case TimeInterval.year:
      case TimeInterval.all:
        return DateFormat('MMM d, yyyy').format(date);
    }
  }

  void _updateTooltip(Offset position) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    
    int index = ((position.dx / size.width) * visiblePoints.length).floor();
    index = index.clamp(0, visiblePoints.length - 1);

    setState(() {
      selectedPoint = visiblePoints[index];
      tooltipPosition = position;
    });
  }

  void _hideTooltip() {
    setState(() {
      selectedPoint = null;
      tooltipPosition = null;
    });
  }
}

class LineChartPainter extends CustomPainter {
  final List<ChartPoint> dataPoints;
  final Color color;
  final ChartPoint? selectedPoint;
  final Animation<double> animation;

  LineChartPainter({
    required this.dataPoints,
    required this.color,
    this.selectedPoint,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withAlpha((0.3 * 255).toInt()),
          color.withAlpha((0.0 * 255).toInt()),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final points = _getPoints(size);
    final animatedPoints = _getAnimatedPoints(points, size);
    final path = _createPath(animatedPoints);
    final fillPath = _createFillPath(path, size);

    // Draw gradient fill
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    canvas.drawPath(path, paint);

    // Draw selected point
    if (selectedPoint != null) {
      final selectedIndex = dataPoints.indexOf(selectedPoint!);
      if (selectedIndex != -1) {
        final dotPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        
        final borderPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

        canvas.drawCircle(animatedPoints[selectedIndex], 6, borderPaint);
        canvas.drawCircle(animatedPoints[selectedIndex], 4, dotPaint);
      }
    }
  }

  List<Offset> _getAnimatedPoints(List<Offset> points, Size size) {
    return points.map((point) {
      final double lerpedY = lerpDouble(size.height, point.dy, animation.value) ?? size.height;
      return Offset(point.dx, lerpedY);
    }).toList();
  }

  Path _createPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint1 = Offset(
        current.dx + (next.dx - current.dx) / 2,
        current.dy,
      );
      final controlPoint2 = Offset(
        current.dx + (next.dx - current.dx) / 2,
        next.dy,
      );
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        next.dx,
        next.dy,
      );
    }
    return path;
  }

  Path _createFillPath(Path linePath, Size size) {
    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return fillPath;
  }

  List<Offset> _getPoints(Size size) {
    if (dataPoints.isEmpty) return [];

    final points = <Offset>[];
    final width = size.width;
    final height = size.height;
    
    final values = dataPoints.map((point) => point.value).toList();
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final valueRange = maxValue - minValue;

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * width;
      final normalizedValue = valueRange > 0 ? (dataPoints[i].value - minValue) / valueRange : 0;
      final y = height - (normalizedValue * height);
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.color != color ||
        oldDelegate.selectedPoint != selectedPoint ||
        oldDelegate.animation != animation;
  }
}