import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const ProfileButton({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
          enableFeedback: true,
            backgroundColor:
                WidgetStatePropertyAll(GlobalVariables.greyBackgroundColor)),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600),));
  }
}
