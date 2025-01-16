import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class BalanceCardEmpty extends StatelessWidget {
  const BalanceCardEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Balance",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: GlobalVariables.secondaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    width: double.infinity,
                    child: const Text(
                      "Add Wallet",
                      style: TextStyle(
                          color: GlobalVariables.backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
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
                          Text("Today's Expense", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Icons.arrow_downward, color: GlobalVariables.secondaryColor,),
                              Text("Rp 0,00", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
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
                          Text("This Week", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),), 
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Icons.arrow_upward_rounded, color: Colors.red,),
                              Text("Rp 0,00", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
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
