import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class TransactionBar extends StatelessWidget {
  final String transactionName, transactionType, transactionCategory;
  final DateTime transactionDate;
  final bool isRecurring;
  final int transactionAmount;
  const TransactionBar({super.key, required this.transactionName, required this.transactionType, required this.transactionDate, required this.transactionCategory, required this.transactionAmount, required this.isRecurring});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transactionType == 'income';
    return Stack(
      children: [
      Container(
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
          child: Text(
            isIncome ? "💸" : getCategoryEmoji(transactionCategory),
            style: const TextStyle(fontSize: 20),
          ),
          ),
          const SizedBox(width: 10),
          Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Row(
              children: [
              Expanded(
                child: Text(
                transactionName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                ),
              ),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              formatDateTime(transactionDate),
              style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
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
          const SizedBox(width: 10),
        ],
        ),
      ),
      if (isRecurring)
        Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
          color: GlobalVariables.secondaryColor,
          borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
          'Recurring',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          ),
        ),
        ),
      ],
    );
  }
}