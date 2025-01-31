import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class TransactionBar extends StatelessWidget {
  final String transactionName, transactionType, transactionCategory;
  final DateTime transactionDate;
  final int transactionAmount;
  const TransactionBar({super.key, required this.transactionName, required this.transactionType, required this.transactionDate, required this.transactionCategory, required this.transactionAmount});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transactionType == 'income';
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GlobalVariables.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(isIncome ? "💸" : getCategoryEmoji(transactionCategory), style: const TextStyle(fontSize: 20),)
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  transactionName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 1,),
                Text(
                  formatDateTime(transactionDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            "${isIncome ? "+" : "-"} ${rupiahFormatCurrency(transactionAmount)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isIncome ? GlobalVariables.secondaryColor : Colors.redAccent,
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}