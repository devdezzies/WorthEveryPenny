import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/custom_switch.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/analytics/widgets/double_chart_plot.dart';
import 'package:swappp/features/analytics/widgets/single_chart_plot.dart';
import 'package:swappp/providers/analytics_provider.dart';
import 'package:swappp/providers/preferences_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String routeName = '/analytics';
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    final AnalyticsProvider analyticsProvider = Provider.of<AnalyticsProvider>(context, listen: false);

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
                          'Total ${isIncome ? 'Income' : 'Expense'}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    // add a picker for daily, weekly, monthly, yearly
                    Wrap(
                      children: [
                        CustomToggleSwitch(onToggle: (choice) {
                          setState(() {
                            isIncome = choice;
                          });
                        },),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
                if (Provider.of<PreferencesProvider>(context).chartType == 'single')
                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: SingleChartPlot(
                      dataPoints: isIncome ? analyticsProvider.incomeData : analyticsProvider.expenseData,
                      valuePrefix: 'Rp',
                      height: 350,
                      chartColor: isIncome ? ChartColor.green : ChartColor.red,
                    ),
                  ),
                if (Provider.of<PreferencesProvider>(context).chartType == 'double')
                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: DoubleChartPlot(
                      incomeData: analyticsProvider.incomeData,
                      expenseData: analyticsProvider.expenseData,
                      isIncomeOnTop: isIncome,
                      valuePrefix: 'Rp',
                      onLayerChanged: (change) {
                        setState(() {
                          isIncome = change;
                        });
                      },
                      height: 350,
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
