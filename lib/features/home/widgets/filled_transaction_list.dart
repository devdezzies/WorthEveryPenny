import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/route_animations.dart';
import 'package:swappp/features/home/widgets/transaction_bar.dart';
import 'package:swappp/features/transaction/screens/transaction_history.dart';
import 'package:swappp/features/transaction/services/transaction_service.dart';
import 'package:swappp/models/user.dart';
import 'package:swappp/providers/user_provider.dart';

class FilledTransactionList extends StatelessWidget {
  const FilledTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final User userProvider = Provider.of<UserProvider>(context, listen: true).user;
    final TransactionService transactionService = TransactionService();
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Text('Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[500])),
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
          height: 5,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userProvider.transactions.length > 10
              ? 10
              : userProvider.transactions.length,
          itemBuilder: (context, index) {
            return TransactionBar(
              key: ValueKey(userProvider.transactions[index].hashCode),
              transactionName: userProvider.transactions[index].name,
              transactionAmount: userProvider.transactions[index].amount,
              transactionDate: userProvider.transactions[index].date,
              isRecurring: userProvider.transactions[index].recurring,
              transactionCategory:
                  userProvider.transactions[index].category ?? 'Utilities',
              transactionType: userProvider.transactions[index].type,
            );
          },
        )
      ],
    );
  }
}
