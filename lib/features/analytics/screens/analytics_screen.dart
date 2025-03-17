import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/custom_switch.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/analytics/widgets/budgets_header.dart';
import 'package:swappp/features/analytics/widgets/month_in_review.dart';
import 'package:swappp/features/analytics/widgets/recurring_section.dart';
import 'package:swappp/features/analytics/widgets/single_chart_plot.dart';
import 'package:swappp/providers/analytics_provider.dart';
import 'package:swappp/providers/user_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String routeName = '/analytics';
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool isIncome = false;

  @override
  Widget build(BuildContext context) {
    final AnalyticsProvider analyticsProvider = Provider.of<AnalyticsProvider>(context, listen: true);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: true);

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
                
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: SingleChartPlot(
                    dataPoints: isIncome ? analyticsProvider.incomeData : analyticsProvider.expenseData,
                    valuePrefix: 'Rp',
                    height: 300,
                    chartColor: isIncome ? ChartColor.green : ChartColor.red,
                  ),
                ),
                
                const SizedBox(height: 15),
                MonthInReview(
                  totalIncome: userProvider.user.monthlyReport[0].totalIncome.toInt(),
                  totalExpense: userProvider.user.monthlyReport[0].totalExpense.toInt(),
                  net: userProvider.user.cash +
                      (userProvider.user.bankAccount.isEmpty
                          ? 0
                          : userProvider.user.bankAccount
                              .map((e) => e.balance.toInt())
                              .reduce((a, b) => a + b)),
                ),
                const SizedBox(height: 15),
                const BudgetHeader(),
                const SizedBox(height: 15),
                const RecurringSection(),
                const SizedBox(height: 100)
              ],
            ),
          ),
        ));
  }
}
