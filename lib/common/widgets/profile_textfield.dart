import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileTextfield extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final String? hintText;
  final TextInputType keyType;
  final String Function(String?)? validator;
  const ProfileTextfield({super.key, required this.controller, required this.prefixIcon, this.hintText, this.keyType = TextInputType.text, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: GlobalVariables.greyBackgroundColor, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyType,
        cursorColor: const Color.fromARGB(255, 73, 70, 70),
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: const TextStyle(color:Color.fromARGB(255, 73, 70, 70)),
          hintText: hintText,
          icon: Icon(prefixIcon, color: const Color.fromARGB(255, 73, 70, 70),),
          border: InputBorder.none,
        ),
      ),
    );
  }
}