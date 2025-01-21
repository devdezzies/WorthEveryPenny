import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/home/widgets/card_content/bank_balance_card_content_empty.dart';
import 'package:swappp/features/home/widgets/card_content/total_balance_card_content.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final PageController _pageController = PageController();
  final Color _overlayColor = const Color.fromARGB(255, 23, 22, 22);

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
              children: const [
                TotalBalanceCardContent(), 
                BankBalanceCardContentEmpty(),
                BankBalanceCardContentEmpty(),
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
                  inActiveColorOverride: (i) => _overlayColor, // Override inactive color
                ),
              ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: GlobalVariables.darkerGreyBackgroundColor, 
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Monthly Income", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                          SizedBox(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_downward, color: GlobalVariables.secondaryColor, ),
                              Text("Rp 2,3 juta", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ), 
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Monthly Expense", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),), 
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Icons.arrow_upward_rounded, color: Colors.red,),
                              Text("Rp 123.500", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
