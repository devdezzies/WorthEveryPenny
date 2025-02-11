import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/global_variables.dart';

class RecurringSection extends StatelessWidget {
  const RecurringSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Recurring Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFFAAAAAA),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  CustomSnackBar.show(context, type: SnackBarType.warning, message: "Feature not available yet");
                  // Handle menu tap
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      color: GlobalVariables.secondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            child: Column(
              children: [
                
              ],
            ),
          )
        ],
      ),
    );
  }
}