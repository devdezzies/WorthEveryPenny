import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/providers/transaction_provider.dart';

class RecurrentPicker extends StatelessWidget {
  const RecurrentPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    final isRecurrent = transactionProvider.transaction.recurring;

    return Row(
      children: [
        const SizedBox(
          width: 70,
          child: Text("Repeat", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final String? result = await showModalBottomSheet<String>(
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
                                child: Text("Repeat", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                              ),
                            ),
                            ListTile(
                              title: const Text("Never"),
                              onTap: () => Navigator.pop(context, "never"),
                            ),
                            ListTile(
                              title: const Text("Daily"),
                              onTap: () => Navigator.pop(context, "daily"),
                            ),
                            ListTile(
                              title: const Text("Weekly"),
                              onTap: () => Navigator.pop(context, "weekly"),
                            ),
                            ListTile(
                              title: const Text("Monthly"),
                              onTap: () => Navigator.pop(context, "monthly"),
                            ),
                            ListTile(
                              title: const Text("Yearly"),
                              onTap: () => Navigator.pop(context, "yearly"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              if (result != null) {
                if (result == "never") {
                  transactionProvider.setRecurring(false);
                } else {
                  transactionProvider.setRecurring(true, result);
                }
              }
            },
            child: Row(
              children: [
                const Icon(Icons.event_repeat_rounded, size: 16,),
                const SizedBox(width: 5),
                Text(transactionProvider.transaction.recurring ? transactionProvider.transaction.recurrenceInterval ?? '' : "Never", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
              ],
            ),
          ),),
      ],
    );
  }
}