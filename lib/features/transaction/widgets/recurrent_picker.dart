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
                              title: const Text("Weekly"),
                              onTap: () => Navigator.pop(context, "weekly"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
              if (result != null) {
                debugPrint(result);
              }
            },
            child: Row(
              children: [
                const Icon(Icons.event_repeat_rounded, size: 16,),
                const SizedBox(width: 5),
                Text(isRecurrent ? "Weekly" : "Never", style: const TextStyle(fontSize: 16),),
              ],
            ),
          ),),
      ],
    );
  }
}