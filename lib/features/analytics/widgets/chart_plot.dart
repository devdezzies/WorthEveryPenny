import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swappp/constants/global_variables.dart';

class ChartPoint {
  final DateTime date;
  final double value;

  ChartPoint(this.date, this.value);
}

enum ChartColor { red, green }

class ChartPlot extends StatefulWidget {
  final List<ChartPoint> dataPoints;
  final ChartColor chartColor;
  final String valuePrefix;
  final double height;

  const ChartPlot({
    super.key,
    required this.dataPoints,
    this.chartColor = ChartColor.red,
    this.valuePrefix = '',
    this.height = 300,
  });

  @override
  ChartPlotState createState() => ChartPlotState();
}

class ChartPlotState extends State<ChartPlot> with SingleTickerProviderStateMixin {
  late int _currentStartIndex;
  ChartPoint? selectedPoint;
  Offset? tooltipPosition;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentStartIndex = max(0, widget.dataPoints.length - 7);
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
    int endIndex = min(_currentStartIndex + 7, widget.dataPoints.length);
    return widget.dataPoints.sublist(_currentStartIndex, endIndex);
  }

  double get intervalTotal {
    return visiblePoints.fold(0, (sum, point) => sum + point.value);
  }

  bool get canGoBack => _currentStartIndex > 0;
  bool get canGoForward => _currentStartIndex + 7 < widget.dataPoints.length;

  void _goBack() {
    if (canGoBack) {
      setState(() {
        _currentStartIndex = max(0, _currentStartIndex - 7);
      });
      _animationController.forward(from: 0);
    }
  }

  void _goForward() {
    if (canGoForward) {
      setState(() {
        _currentStartIndex = min(widget.dataPoints.length - 7, _currentStartIndex + 7);
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
          _buildDateLabels(),
          const SizedBox(height: 10),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildIntervalTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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

  Widget _buildDateLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: visiblePoints.map((point) {
        return Container(
          width: 50,
          child: Column(
            children: [
              Container(
                width: 2,
                height: 15,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM d').format(point.date),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: canGoBack ? _goBack : null,
          color: canGoBack ? Colors.white : Colors.white.withOpacity(0.3),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: canGoForward ? _goForward : null,
          color: canGoForward ? Colors.white : Colors.white.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildTooltip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.valuePrefix}${selectedPoint!.value.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            DateFormat('MMM d, yyyy').format(selectedPoint!.date),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
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
    if (dataPoints.isEmpty) return;

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
          color.withOpacity(0.3),
          color.withOpacity(0.0),
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
      return Offset(point.dx, lerpDouble(size.height, point.dy, animation.value)!);
    }).toList();
  }

  Path _createPath(List<Offset> points) {
    final path = Path();
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
      final normalizedValue = (dataPoints[i].value - minValue) / valueRange;
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