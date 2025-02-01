import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionNameField extends StatefulWidget {
  final TextEditingController controller;
  const TransactionNameField({super.key, required this.controller});

  @override
  State<TransactionNameField> createState() => _TransactionNameFieldState();
}

class _TransactionNameFieldState extends State<TransactionNameField> {
  String chosenEmoji = "Utilities";

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);
    final isIncome = transactionProvider.transaction.type == "income";
    return Container(
      decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(40)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (isIncome) {
                return;
              }
              final emoji = await showModalBottomSheet<String>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 70,
                              child: Center(
                                  child: Text("Select Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20))),
                            ),
                            ...categories.map((category) {
                              return ListTile(
                                title: Text('${category["emoji"]} ${category["title"]}'),
                                onTap: () =>
                                    Navigator.pop(context, category["title"]),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              if (emoji != null) {
                setState(() {
                  chosenEmoji = emoji;
                });
                transactionProvider.transaction.category = categories.firstWhere(
                    (element) => element["title"] == emoji)["title"];
              }
            },
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: GlobalVariables.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Text(isIncome ? '💸' : getCategoryEmoji(chosenEmoji),
                  style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLength: 50,
              style: const TextStyle(fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                counterText: '',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                hintText: 'What is this transaction for?',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                if (text.length == 35) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content:
                          const Text('Oh No, You have typed 35 characters'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
