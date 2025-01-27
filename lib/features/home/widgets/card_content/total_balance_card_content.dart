import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class TotalBalanceCardContent extends StatelessWidget {
  const TotalBalanceCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Total Balance",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                "🌳 Updated 2 minutes ago",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: GlobalVariables.secondaryColor),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text("Rp 5,250,000.00", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),)
        ],
      ),
    );
  }
}