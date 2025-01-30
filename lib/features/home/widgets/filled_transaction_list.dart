import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/home/widgets/transaction_bar.dart';
import 'package:swappp/models/user.dart';
import 'package:swappp/providers/user_provider.dart';

class FilledTransactionList extends StatelessWidget {
  const FilledTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final User userProvider = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        const SizedBox(height: 10,),
        const Row(children: [
          SizedBox(width: 5,),
          Text('Recent Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Spacer(),
          Text('See all', style: TextStyle(fontSize: 15, color: GlobalVariables.secondaryColor, fontWeight: FontWeight.w700)),
          SizedBox(width: 10,),
        ],),
        const SizedBox(height: 5,),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userProvider.transactions.length > 10 ? 10 : userProvider.transactions.length,
            itemBuilder: (context, index) {
            return TransactionBar(
              transactionName: userProvider.transactions[index].name,
              transactionAmount: userProvider.transactions[index].amount,
              transactionDate: userProvider.transactions[index].date,
              transactionCategory: userProvider.transactions[index].category ?? 'Utilities',
              transactionType: userProvider.transactions[index].type,
            );
          },
        )
      ],
    );
  
  }
}
