import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class BankBalanceCardContentFilled extends StatelessWidget {
  final int totalBalance, numberOfAccounts;
  const BankBalanceCardContentFilled({super.key, required this.totalBalance, required this.numberOfAccounts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Bank",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey[500]),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: GlobalVariables.darkerGreyBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 15,
                      color: GlobalVariables.secondaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${numberOfAccounts} accounts connected",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: GlobalVariables.secondaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${rupiahFormatCurrency(totalBalance)}.00",
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
