import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalWallet extends StatelessWidget {
  const GoalWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 180,
      height: 220,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Goal Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/log-in-screen');
                      // Handle menu tap
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFFAAAAAA),
                      size: 20,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SfCircularChart(
                    margin: EdgeInsets.zero,
                    series: [
                    RadialBarSeries<_ChartData, String>(
                      dataSource: [
                      _ChartData(
                        'My Goal', 60, GlobalVariables.secondaryColor),
                      ],
                      trackOpacity: 0.3,
                      useSeriesColor: true,
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.y,
                      pointColorMapper: (data, _) => data.barColor,
                      cornerStyle: CornerStyle.bothCurve,
                      maximumValue: 100,
                      radius: '95%',
                      innerRadius:
                        '70%', // Added innerRadius to make the chart thinner
                    )
                    ],
                  ),
                  const Text(
                    '60%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GlobalVariables.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 15, top: 10),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                child: const Text(
                  "Set Your Goal",
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.barColor);
  final String x;
  final double y;
  final Color barColor;
}
