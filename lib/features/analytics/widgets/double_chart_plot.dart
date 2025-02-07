import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/analytics/data/chart_point.dart';

class DoubleChartPlot extends StatefulWidget {
  final List<ChartPoint> incomeData;
  final List<ChartPoint> expenseData;
  final String valuePrefix;
  final double height;
  final bool isIncomeOnTop;
  final Function(bool) onLayerChanged;

  const DoubleChartPlot({
    super.key,
    required this.incomeData,
    required this.expenseData,
    this.valuePrefix = '',
    this.height = 300,
    this.isIncomeOnTop = true,
    required this.onLayerChanged,
  });

  @override
  DoubleChartPlotState createState() => DoubleChartPlotState();
}

class DoubleChartPlotState extends State<DoubleChartPlot>
    with SingleTickerProviderStateMixin {
  late int _currentStartIndex;
  ChartPoint? selectedPoint;
  Offset? tooltipPosition;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _currentStartIndex = max(0, widget.incomeData.length - 7);
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

  List<ChartPoint> get visiblePoints {
    int endIndex = min(_currentStartIndex + 7, widget.incomeData.length);
    return widget.isIncomeOnTop
        ? widget.incomeData.sublist(_currentStartIndex, endIndex)
        : widget.expenseData.sublist(_currentStartIndex, endIndex);
  }

  double get intervalTotal {
    return visiblePoints.fold(0, (sum, point) => sum + point.value);
  }

  bool get canGoBack => _currentStartIndex > 0;
  bool get canGoForward => _currentStartIndex + 7 < widget.incomeData.length;

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
        _currentStartIndex =
            min(widget.incomeData.length - 7, _currentStartIndex + 7);
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
                    onPanDown: (details) =>
                        _updateTooltip(details.localPosition),
                    onPanUpdate: (details) =>
                        _updateTooltip(details.localPosition),
                    onPanEnd: (_) => _hideTooltip(),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size.infinite,
                          painter: OverlappingLineChartPainter(
                            incomeData: widget.incomeData.sublist(
                                _currentStartIndex, _currentStartIndex + 7),
                            expenseData: widget.expenseData.sublist(
                                _currentStartIndex, _currentStartIndex + 7),
                            incomeColor: GlobalVariables.secondaryColor,
                            expenseColor: const Color(0xFFE53935),
                            selectedPoint: selectedPoint,
                            animation: _animation,
                            isIncomeOnTop: widget.isIncomeOnTop,
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.valuePrefix}${NumberFormat('#,##0').format(value)}',
                style: TextStyle(
                  color: widget.isIncomeOnTop
                      ? GlobalVariables.secondaryColor
                      : const Color(0xFFE53935),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: visiblePoints.map((point) {
        return SizedBox(
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
        color: Colors.black.withOpacity(0.7),
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
            DateFormat('MMM d, yyyy').format(selectedPoint!.date),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rupiahFormatCurrency(selectedPoint!.value.toInt()),
            style: TextStyle(
              color: widget.isIncomeOnTop
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

class OverlappingLineChartPainter extends CustomPainter {
  final List<ChartPoint> incomeData;
  final List<ChartPoint> expenseData;
  final Color incomeColor;
  final Color expenseColor;
  final ChartPoint? selectedPoint;
  final Animation<double> animation;
  final bool isIncomeOnTop;

  OverlappingLineChartPainter({
    required this.incomeData,
    required this.expenseData,
    required this.incomeColor,
    required this.expenseColor,
    this.selectedPoint,
    required this.animation,
    required this.isIncomeOnTop,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (incomeData.isEmpty || expenseData.isEmpty) return;

    final incomePaint = Paint()
      ..color = incomeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final expensePaint = Paint()
      ..color = expenseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final incomeFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          incomeColor.withOpacity(0.3),
          incomeColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final expenseFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          expenseColor.withOpacity(0.3),
          expenseColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final incomePoints = _getPoints(size, incomeData);
    final expensePoints = _getPoints(size, expenseData);

    final animatedIncomePoints = _getAnimatedPoints(incomePoints, size);
    final animatedExpensePoints = _getAnimatedPoints(expensePoints, size);

    final incomePath = _createPath(animatedIncomePoints);
    final expensePath = _createPath(animatedExpensePoints);

    final incomeFillPath = _createFillPath(incomePath, size);
    final expenseFillPath = _createFillPath(expensePath, size);

    // Draw charts based on isIncomeOnTop parameter
    if (isIncomeOnTop) {
      _drawChart(
          canvas, expensePath, expenseFillPath, expensePaint, expenseFillPaint);
      _drawChart(
          canvas, incomePath, incomeFillPath, incomePaint, incomeFillPaint);
    } else {
      _drawChart(
          canvas, incomePath, incomeFillPath, incomePaint, incomeFillPaint);
      _drawChart(
          canvas, expensePath, expenseFillPath, expensePaint, expenseFillPaint);
    }

    // Draw selected point
    if (selectedPoint != null) {
      final selectedPoints =
          isIncomeOnTop ? animatedIncomePoints : animatedExpensePoints;
      final selectedIndex =
          (isIncomeOnTop ? incomeData : expenseData).indexOf(selectedPoint!);
      if (selectedIndex != -1) {
        _drawSelectedPoint(canvas, selectedPoints[selectedIndex],
            isIncomeOnTop ? incomePaint : expensePaint);
      }
    }
  }

  void _drawChart(Canvas canvas, Path linePath, Path fillPath, Paint linePaint,
      Paint fillPaint) {
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  void _drawSelectedPoint(Canvas canvas, Offset point, Paint paint) {
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(point, 6, borderPaint);
    canvas.drawCircle(point, 4, dotPaint);
  }

  List<Offset> _getAnimatedPoints(List<Offset> points, Size size) {
    return points.map((point) {
      return Offset(
          point.dx, lerpDouble(size.height, point.dy, animation.value)!);
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

  List<Offset> _getPoints(Size size, List<ChartPoint> data) {
    if (data.isEmpty) return [];

    final points = <Offset>[];
    final width = size.width;
    final height = size.height;

    final values = data.map((point) => point.value).toList();
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final valueRange = maxValue - minValue;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * width;
      final normalizedValue = (data[i].value - minValue) / valueRange;
      final y = height - (normalizedValue * height);
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(OverlappingLineChartPainter oldDelegate) {
    return oldDelegate.incomeData != incomeData ||
        oldDelegate.expenseData != expenseData ||
        oldDelegate.incomeColor != incomeColor ||
        oldDelegate.expenseColor != expenseColor ||
        oldDelegate.selectedPoint != selectedPoint ||
        oldDelegate.animation != animation ||
        oldDelegate.isIncomeOnTop != isIncomeOnTop;
  }
}
