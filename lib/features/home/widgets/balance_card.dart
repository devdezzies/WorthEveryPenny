import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/route_animations.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/bank/screens/bank_manager_screen.dart';
import 'package:swappp/features/home/widgets/card_content/bank_balance_card_content_empty.dart';
import 'package:swappp/features/home/widgets/card_content/bank_balance_card_content_filled.dart';
import 'package:swappp/features/home/widgets/card_content/cash_balance_card_content.dart';
import 'package:swappp/features/home/widgets/card_content/total_balance_card_content.dart';
import 'package:swappp/providers/user_provider.dart';

class BalanceCard extends StatefulWidget {
  final int income, expense, totalBalance;
  final double expensePercentage;
  final DateTime lastUpdated;
  const BalanceCard(
      {super.key,
      required this.income,
      required this.expense,
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final int bankTotalBalance = userProvider.user.bankAccount.isEmpty
        ? 0
        : userProvider.user.bankAccount
            .map((e) => e.balance.toInt())
            .reduce((value, element) => value + element);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 210,
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
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
                GestureDetector(
                    onTap: () => Navigator.of(context).push(createRouteCustom(
                        const BankManagerScreen(),
                        const Offset(1.0, 0.0),
                        Offset.zero,
                        Curves.ease)),
                    child: userProvider.user.bankAccount.isEmpty
                        ? const BankBalanceCardContentEmpty()
                        : BankBalanceCardContentFilled(
                            totalBalance: bankTotalBalance,
                            numberOfAccounts:
                                userProvider.user.bankAccount.length)),
                CashBalanceCardContent(cashAmount: userProvider.user.cash),
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
                  color: GlobalVariables.greyBackgroundColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          GlobalVariables.secondaryColor.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.trending_up_rounded,
                                    size: 22,
                                    color: GlobalVariables.secondaryColor,
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Income",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color:
                                          Color.fromARGB(255, 175, 175, 175)),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  rupiahFormatCurrency(widget.income),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: VerticalDivider(
                      color: Color.fromARGB(255, 56, 56, 56),
                      thickness: 1,
                      width: 1,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.redAccent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.trending_down_rounded,
                                    size: 22,
                                    color: Colors.redAccent,
                                  ),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Expense",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color:
                                          Color.fromARGB(255, 175, 175, 175)),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  rupiahFormatCurrency(widget.expense),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
