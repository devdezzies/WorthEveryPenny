import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
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
    final sourceOptions = [
      {
        "source": "cash",
        "balance": userProvider.user.cash,
        "accountNumber": "cash"
      },
      ...userProvider.user.bankAccount.map((entry) => {
        "source": entry.bankName,
        "balance": entry.balance,
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
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 70,
                              child: Center(
                                child: Text(
                                  "Pick a Source",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                height: 300, // Set a fixed height
                                child: ListView.builder(
                                  itemCount: sourceOptions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: ChoiceChip(
                                        backgroundColor: GlobalVariables.greyBackgroundColor,
                                        selectedColor: GlobalVariables.secondaryColor,
                                        label: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          width: double.infinity,
                                          child: Text(
                                            sourceOptions[index]["source"].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: selectedChoice == index
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
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
                      ),
                    ),
                  );
                },
              );
              if (result != null) {
                setState(() {
                  selectedChoice = result;
                });
                debugPrint(result.toString());
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
