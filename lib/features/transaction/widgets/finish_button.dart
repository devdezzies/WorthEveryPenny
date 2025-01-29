import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class FinishButton extends StatelessWidget {
  final void Function() onTap;
  const FinishButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: GlobalVariables.secondaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            'Wrap Up',
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
