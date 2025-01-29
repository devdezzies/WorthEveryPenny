import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class SourcePicker extends StatelessWidget {
  const SourcePicker({super.key});

  @override
  Widget build(BuildContext context) {
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
                                child: Text(
                                  "Source of Transaction",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              String selectedChoice = "cash";
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    ChoiceChip(
                                        backgroundColor:
                                            GlobalVariables.greyBackgroundColor,
                                        selectedColor: GlobalVariables.secondaryColor,
                                        label: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          width: double.infinity,
                                          child: const Text("Cash", style: TextStyle(fontWeight: FontWeight.w700),),
                                        ),
                                        selected: selectedChoice == 'cash',
                                        onSelected: (bool selected) {
                                          setState(() {
                                            selectedChoice = 'cash';
                                          });
                                        }),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            }),
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
            child: const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 16,
                ),
                SizedBox(width: 5),
                Text(
                  "Cash",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
