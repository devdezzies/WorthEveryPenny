import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class PremiumSubscriptionField extends StatelessWidget {
  const PremiumSubscriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: GlobalVariables.greyBackgroundColor,),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(82, 81, 81, 81)),
            child: const Center(
              child: Text("👑", style: TextStyle(fontSize: 25),),
            ),
          ), 
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Premium Plan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),), 
              Text("Expiration Date: -")
            ],
          )
        ],
      ),
    );
  }
}