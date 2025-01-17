import 'package:flutter/material.dart';

class EmptyTransactionList extends StatelessWidget {
  const EmptyTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Transactions",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            Text("See More")
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Center(
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
