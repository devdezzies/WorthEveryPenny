import 'package:flutter/material.dart';
import 'package:swappp/constants/utils.dart';

class SpendingPulse extends StatelessWidget {
  final double value;
  const SpendingPulse({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final FinancialInsight currentPulse = getFinancialInsight(value, 'expense');
    return GestureDetector(
      onTap: () {
        showFinancialMetricsGuide(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: const Color(0xFF1A1A1A)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GradientIntensityMeter(value: value),
                const SizedBox(width: 10),
              ],
            ),
              Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                currentPulse.insight,
                style: TextStyle(
                  color: Colors.grey[500], fontWeight: FontWeight.w500),
                overflow: TextOverflow.visible,
                ),
              ),
              ),
            Text(
              currentPulse.emoji,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, 
                  fontSize: 20,),
            )
          ],
        ),
      ),
    );
  }
}
