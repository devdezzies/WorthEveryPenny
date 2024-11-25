import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscured;
  const CustomTextfield(
      {super.key, required this.controller, required this.hintText, this.obscured = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: obscured,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide:
                BorderSide(color: GlobalVariables.darkerGreyBackgroundColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide:
                BorderSide(color: GlobalVariables.darkerGreyBackgroundColor),
          ),
        ),
        validator: (val) {});
  }
}
