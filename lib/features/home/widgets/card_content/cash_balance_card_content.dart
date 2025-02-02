import 'package:flutter/material.dart';
import 'package:swappp/constants/utils.dart';

class CashBalanceCardContent extends StatelessWidget {
  final int cashAmount;
  const CashBalanceCardContent({super.key, this.cashAmount = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Cash",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey[500]),
          ),
          const SizedBox(height: 10),
          Text(
            rupiahFormatCurrency(cashAmount),
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}