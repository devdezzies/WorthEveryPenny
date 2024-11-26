import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class CustomButton extends StatelessWidget {
  final String textTitle;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.textTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: GlobalVariables.secondaryColor,
        ),
        child: Text(
          textTitle,
          style: const TextStyle(color: GlobalVariables.backgroundColor, fontWeight: FontWeight.bold),
        ));
  }
}
