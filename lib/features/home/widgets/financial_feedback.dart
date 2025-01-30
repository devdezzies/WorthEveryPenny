import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class FinancialFeedback extends StatelessWidget {
  const FinancialFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            // create a circular area with an emoji at the center
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: GlobalVariables.backgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Text(
                  "😊",
                  style: TextStyle(fontSize: 20),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Review budget before buying more",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[300],
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 5),
                const Text("")
              ],
            ),

            const SizedBox(
              width: 20,
            ),

          ],
        ));
  }
}
