import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/transaction_provider.dart';
import 'package:swappp/providers/user_provider.dart';

class SourcePicker extends StatefulWidget {
  const SourcePicker({super.key});

  @override
  State<SourcePicker> createState() => _SourcePickerState();
}

class _SourcePickerState extends State<SourcePicker> {
  int selectedChoice = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final sourceOptions = [
      {
        "source": "cash",
        "balance": userProvider.user.cash,
        "accountNumber": "cash"
      },
      ...userProvider.user.bankAccount.map((entry) => {
            "source": entry.bankName,
            "balance": entry.balance.toInt(),
            "accountNumber": entry.accountNumber
          })
    ];

    return Row(
      children: [
        const SizedBox(
          width: 70,
          child: Text(
            "Source",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final int? result = await showModalBottomSheet<int>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                          child: Center(
                            child: Text(
                              "Pick a Source",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: sourceOptions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ChoiceChip(
                                    showCheckmark: false,
                                    backgroundColor:
                                        GlobalVariables.greyBackgroundColor,
                                    selectedColor:
                                        GlobalVariables.secondaryColor,
                                    disabledColor: Colors.grey[500],
                                    shape: selectedChoice == index
                                        ? null
                                        : RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.grey[500]!),
                                          ),
                                    label: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sourceOptions[index]["source"]
                                                .toString().toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: selectedChoice == index
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          if (sourceOptions[index]["accountNumber"] != "cash")
                                            Text(
                                              'Account Number: ${sourceOptions[index]["accountNumber"]}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: selectedChoice == index
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Balance: ${rupiahFormatCurrency(sourceOptions[index]["balance"] as int)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: selectedChoice == index
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    selected: selectedChoice == index,
                                    onSelected: (bool selected) {
                                      Navigator.pop(context, index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
              if (result != null) {
                setState(() {
                  selectedChoice = result;
                });
                transactionProvider
                    .setSource(sourceOptions[selectedChoice]["source"] == "cash" ? "cash" :  sourceOptions[selectedChoice]["accountNumber"] as String);
              }
            },
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  sourceOptions[selectedChoice]["source"].toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
