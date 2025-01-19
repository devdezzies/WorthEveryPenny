import 'package:flutter/material.dart';
import '../../../../constants/global_variables.dart';

class BankBalanceCardContentEmpty extends StatelessWidget {
  const BankBalanceCardContentEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Bank Account",
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
    );
  }
}
