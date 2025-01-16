import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalWalletEmpty extends StatelessWidget {
  const GoalWalletEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 180,
      height: 220,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 121, 173, 58),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Goal Wallet",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color.fromARGB(139, 252, 251, 251)),
            textAlign: TextAlign.start,
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: GlobalVariables.backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              child: const Text(
                "Set Your Goal",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
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
