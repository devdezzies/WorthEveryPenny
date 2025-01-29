import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionTypePicker extends StatelessWidget {
  const TransactionTypePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);
    int selectedIndex =
        transactionProvider.transaction.type == 'income' ? 0 : 1;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: ChoiceChip(
                backgroundColor: GlobalVariables.greyBackgroundColor,
                selectedColor: GlobalVariables.secondaryColor,
                side: const BorderSide(width: 0),
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text('Income',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                selected: selectedIndex == 0,
                onSelected: (bool selected) {
                  transactionProvider.setTransactionType('income');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                backgroundColor: GlobalVariables.greyBackgroundColor,
                selectedColor: Colors.redAccent,
                side: const BorderSide(width: 0),
                label: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Expense',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
                selected: selectedIndex == 1,
                onSelected: (bool selected) {
                  transactionProvider.setTransactionType('expense');
                },
              ),
            ),
          ],
        ));
  }
}
