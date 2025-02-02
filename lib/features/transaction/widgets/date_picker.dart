import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/transaction_provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    DateTime selectedDate = transactionProvider.transaction.date;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                transactionProvider.setTransactionDate(pickedDate);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: GlobalVariables.greyBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text(
                      "Date",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    selectedDate.day == DateTime.now().day
                        ? 'Today'
                        : '${monthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
