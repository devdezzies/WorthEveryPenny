import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileTextfield extends StatelessWidget {
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool enableEditing;
  final String prefixText;
  final String? hintText;
  final TextInputType keyType;
  final String Function(String?)? validator;
  const ProfileTextfield({super.key, required this.controller, required this.prefixIcon, this.hintText, this.keyType = TextInputType.text, this.validator, required this.prefixText, this.enableEditing = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(color: GlobalVariables.greyBackgroundColor, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        enabled: enableEditing,
        validator: validator,
        controller: controller,
        keyboardType: keyType,
        cursorColor: const Color.fromARGB(255, 73, 70, 70),
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 73, 70, 70)),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          prefixText: prefixText,
          hintStyle: const TextStyle(color: Colors.white),
          hintText: hintText,
          icon: Icon(prefixIcon, color: Colors.white,),
          border: InputBorder.none,
        ),
      ),
    );
  }
}