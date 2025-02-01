import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swappp/common/widgets/custom_button.dart';
import 'package:swappp/common/widgets/custom_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/home/widgets/card_content/bank_balance_card_content_empty.dart';
import 'package:swappp/features/home/widgets/card_content/total_balance_card_content.dart';

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
  final PageController _pageControllerBottom = PageController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final Color _overlayColor = const Color.fromARGB(255, 23, 22, 22);

  @override
  void dispose() {
    _pageController.dispose();
    _pageControllerBottom.dispose();
    _balanceController.dispose();
    _bankNameController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageControllerBottom.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget _previewCardsView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                "Your Bank Cards",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...List.generate(1, (index) => Text(index.toString())),
            ],
          ),
          SafeArea(
              child: Column(
            children: [
              CustomButton(
                  textTitle: "Add New Card",
                  onTap: () {
                    _nextPage();
                  }),
              const SizedBox(height: 15),
            ],
          ))
        ],
      ),
    );
  }

  Widget _addNewCardView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                "Add New Card",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),
              CustomTextfield(
                  controller: _cardNumberController, hintText: "Card Number"),
              const SizedBox(height: 15),
              CustomTextfield(
                  controller: _bankNameController, hintText: "Bank Name"),
              const SizedBox(height: 15),
              CustomTextfield(
                  controller: _balanceController, hintText: "Current Balance"),
              const SizedBox(height: 25),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(
                    color: Colors.grey[700],
                    thickness: 1,
                    height: 1,
                  ),
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const Text(
                      "Connect via Open Finance",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900]),
                child: Center(
                  child: Text("Brankas (coming soon)", style: TextStyle(color: Colors.grey[600],  fontWeight: FontWeight.w700),),
                ),
              )
            ],
          ),
          SafeArea(
              child: Column(
            children: [
              CustomButton(
                  textTitle: "Finish",
                  onTap: () {
                    _nextPage();
                  }),
              const SizedBox(height: 15),
            ],
          ))
        ],
      ),
    );
  }

  void _showBottomModalView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: GlobalVariables.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: GlobalVariables.greyBackgroundColor,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageControllerBottom,
                        children: [
                          _previewCardsView(),
                          _addNewCardView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                    onTap: () => _showBottomModalView(context),
                    child: const BankBalanceCardContentEmpty()),
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
                                          const Color.fromARGB(255, 56, 56, 56),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.trending_up_rounded,
                                    size: 22,
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
                                          const Color.fromARGB(255, 56, 56, 56),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.trending_down_rounded,
                                      size: 22),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Spend",
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
