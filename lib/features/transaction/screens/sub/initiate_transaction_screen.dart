import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/transaction/services/transaction_service.dart';
import 'package:swappp/features/transaction/widgets/date_picker.dart';
import 'package:swappp/features/transaction/widgets/finish_button.dart';
import 'package:swappp/features/transaction/widgets/recurrent_picker.dart';
import 'package:swappp/features/transaction/widgets/source_picker.dart';
import 'package:swappp/features/transaction/widgets/transaction_name_field.dart';
import 'package:swappp/features/transaction/widgets/transaction_type_picker.dart';
import 'package:swappp/providers/transaction_provider.dart';

class InitiateTransactionScreen extends StatelessWidget {
  const InitiateTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionService transactionService = TransactionService();
    final TextEditingController transactionNameController =
        TextEditingController();
    final TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const TransactionTypePicker(),
              const SizedBox(
                height: 10,
              ),
              TransactionNameField(
                controller: transactionNameController,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: GlobalVariables.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    DatePicker(),
                    Divider(color: Color.fromARGB(85, 158, 158, 158)),
                    SizedBox(
                      height: 10,
                    ),
                    RecurrentPicker(),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: Color.fromARGB(85, 158, 158, 158)),
                    SizedBox(
                      height: 10,
                    ),
                    SourcePicker(),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
          FinishButton(
            onTap: () async {
              if (transactionNameController.text.isNotEmpty) {
                transactionProvider.transaction.name = transactionNameController.text;
              }
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: Lottie.asset('assets/lottie/dollar_refresh.json'),
                  );
                },
              );
              await transactionService.addTransaction(context);
              await Future.delayed(const Duration(seconds: 1));
          
              if (context.mounted) {
                Navigator.of(context).pop();
                await Future.delayed(const Duration(milliseconds: 300));
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
              
              transactionProvider.resetTransaction();
            },
          ),
        ],
      ),
    );
  }
}
