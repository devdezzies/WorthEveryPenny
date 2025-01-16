import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class PersonalizedInsightEmpty extends StatelessWidget {
  const PersonalizedInsightEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 180,
      height: 220,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 121, 173, 58),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          const Text(
            "Personalized Insight",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color.fromARGB(139, 252, 251, 251)),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
              "Before you dive in, let's tailor your experience",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              textAlign: TextAlign.center,
            )),
          ), 
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 15, top: 10),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: GlobalVariables.backgroundColor, borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              child: const Text("Start", style: TextStyle(fontWeight: FontWeight.w700),),
            ),
          )
        ],
      ),
    );
  }
}
