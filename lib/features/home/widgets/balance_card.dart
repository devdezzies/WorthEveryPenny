import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/home/widgets/card_content/bank_balance_card_content_empty.dart';
import 'package:swappp/features/home/widgets/card_content/total_balance_card_content.dart';

class BalanceCard extends StatefulWidget {
  final int income, expense, totalBalance;
  final double expensePercentage, incomePercentage;
  final DateTime lastUpdated;
  const BalanceCard(
      {super.key,
      required this.income,
      required this.expense,
      required this.incomePercentage,
      required this.expensePercentage,
      required this.totalBalance,
      required this.lastUpdated});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final PageController _pageController = PageController();
  final Color _overlayColor = const Color.fromARGB(255, 23, 22, 22);

  @override
  Widget build(BuildContext context) {
    final FinancialInsight incomeInsight = getFinancialInsight(widget.incomePercentage, 'income');
    final FinancialInsight expenseInsight = getFinancialInsight(widget.expensePercentage, 'expense');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210,
      decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SizedBox(
            height: 110,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              children: [
                TotalBalanceCardContent(
                  totalBalance: widget.totalBalance,
                  lastUpdated: widget.lastUpdated,
                ),
                const BankBalanceCardContentEmpty(),
                const BankBalanceCardContentEmpty(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 8,
                  color: GlobalVariables.secondaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                dotDecoration: DotDecoration(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 8,
                  color: _overlayColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                spacing: 5.0, // No spacing between the bars
                inActiveColorOverride: (i) =>
                    _overlayColor, // Override inactive color
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: GlobalVariables.darkerGreyBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${expenseInsight.emoji} Expense",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 175, 175, 175)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                  child: GradientIntensityMeter(
                                      value: widget.expensePercentage)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                rupiahFormatCurrency(widget.expense),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${incomeInsight.emoji} Income",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color:
                                        Color.fromARGB(255, 175, 175, 175)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                rupiahFormatCurrency(widget.income),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
