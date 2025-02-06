import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_switch.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/analytics/widgets/chart_plot.dart';

class AnalyticsScreen extends StatelessWidget {
  static const String routeName = '/analytics';
  AnalyticsScreen({super.key});

  // Sample data for weekly chart
  final List<ChartPoint> weeklyData = List.generate(
    7,
    (index) => ChartPoint(
      DateTime.now().subtract(Duration(days: 6 - index)),
      20 + Random().nextDouble() * 30,
    ),
  );

  // Sample data for monthly chart
  final List<ChartPoint> monthlyData = List.generate(
    30,
    (index) => ChartPoint(
      DateTime.now().subtract(Duration(days: 29 - index)),
      20 + index * 0.5 + Random().nextDouble() * 5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.backgroundColor,
          title: const Text('Analytics',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30)),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          'Total Income',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    // add a picker for daily, weekly, monthly, yearly
                    const Wrap(
                      children: [
                        CustomToggleSwitch(),
                        SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: Text(
                    'Rp 2,500,000',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                      color: GlobalVariables.secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 300,
                  child: ChartPlot(
                    dataPoints: monthlyData,
                    chartColor: ChartColor.green,
                    valuePrefix: 'Rp',
                    height: 300,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
