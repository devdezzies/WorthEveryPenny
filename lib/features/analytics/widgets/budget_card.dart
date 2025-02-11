import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'dart:math' as math;

import 'package:swappp/constants/global_variables.dart';

class BudgetCard extends StatelessWidget {
  final String category;
  final String emoji;
  final double spent;
  final double total;
  final List<Color> gradientColors;

  const BudgetCard({
    Key? key,
    required this.category,
    required this.emoji,
    required this.spent,
    required this.total,
    required this.gradientColors,
  }) : super(key: key);

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: GlobalVariables.backgroundColor,
      isScrollControlled: true,
      builder: (context) => BudgetDetailsSheet(
        category: category,
        emoji: emoji,
        spent: spent,
        total: total,
        gradientColors: gradientColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = spent / total;
    
    return GestureDetector(
      onTap: () {
        CustomSnackBar.show(context, type: SnackBarType.warning, message: "Feature not available yet");
       // _showDetailsSheet(context);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
            children: [
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
                ),
                const SizedBox(height: 8),
                Text(
                '${spent.toInt()}k',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                ),
                Text(
                'spent',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                ),
                const SizedBox(height: 4),
                Text(
                '${(total - spent).toInt()}k',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                ),
                Text(
                'left',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                ),
              ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                // Glow effect
                Container(
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                    color: gradientColors[0].withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    ),
                  ],
                  ),
                ),
                // Progress indicator
                CustomPaint(
                  size: const Size(60, 60),
                  painter: CircularProgressPainter(
                  progress: progress,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  progressColor: GlobalVariables.secondaryColor,
                  strokeWidth: 5,
                  ),
                ),
                // Centered emoji
                Center(
                  child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 25),
                  ),
                  ),
                ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class BudgetDetailsSheet extends StatelessWidget {
  final String category;
  final String emoji;
  final double spent;
  final double total;
  final List<Color> gradientColors;

  const BudgetDetailsSheet({
    Key? key,
    required this.category,
    required this.emoji,
    required this.spent,
    required this.total,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = spent / total;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          
          // Header with Progress
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _ProgressBar(
                        progress: progress,
                        gradientColors: gradientColors,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${(progress * 100).toInt()}% of budget used',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Budget Overview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BudgetStat(
                    label: 'Spent',
                    amount: spent,
                    textColor: Colors.redAccent,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[800],
                  ),
                  _BudgetStat(
                    label: 'Left',
                    amount: total - spent,
                    textColor: GlobalVariables.secondaryColor,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[800],
                  ),
                  _BudgetStat(
                    label: 'Total',
                    amount: total,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Recent Transactions
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _TransactionItem(
                  title: 'Transaction ${index + 1}',
                  amount: (index + 1) * 20.0,
                  date: DateTime.now().subtract(Duration(days: index)),
                  emoji: emoji,
                  gradientColors: gradientColors,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final List<Color> gradientColors;

  const _ProgressBar({
    required this.progress,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(3),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth * progress,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  GlobalVariables.secondaryColor,
                  GlobalVariables.secondaryColor
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        },
      ),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label;
  final double amount;
  final Color textColor;

  const _BudgetStat({
    required this.label,
    required this.amount,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toInt()}k',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String emoji;
  final List<Color> gradientColors;

  const _TransactionItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.emoji,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradientColors[0].withOpacity(0.2),
                  gradientColors[1].withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- Rp${amount.toInt()}k',
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}