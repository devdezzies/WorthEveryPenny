import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/route_animations.dart';
import 'package:swappp/features/transaction/screens/transaction_history.dart';
import 'package:swappp/features/transaction/services/transaction_service.dart';

class EmptyTransactionList extends StatelessWidget {
  const EmptyTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionService transactionService = TransactionService();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 5,
            ),
            const Text('Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                transactionService.getCategorizedTransactions(context);
                Navigator.of(context).push(createRouteCustom(const TransactionHistory(), const Offset(1.0, 0.0), Offset.zero, Curves.ease));
              },
                child: const Text('See all',
                    style: TextStyle(
                        fontSize: 15,
                        color: GlobalVariables.secondaryColor,
                        fontWeight: FontWeight.w700))),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        const Center(
          child: Text(
              'Looks like you haven\'t made\n '
              'any transactions yet!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        )
      ],
    );
  }
}
