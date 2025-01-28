import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class TotalBalanceCardContent extends StatelessWidget {
  final int totalBalance;
  final DateTime lastUpdated;
  const TotalBalanceCardContent({super.key, required this.totalBalance, required this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Total Balance",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                "🌳 Updated ${countTimeAgo(lastUpdated)}",
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: GlobalVariables.secondaryColor),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(rupiahFormatCurrency(totalBalance), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),)
        ],
      ),
    );
  }
}