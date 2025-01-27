import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const CustomTextfield(
      {super.key, required this.controller, required this.hintText});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: GlobalVariables.greyBackgroundColor, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
          controller: widget.controller,
          cursorColor: const Color.fromARGB(255, 73, 70, 70),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            border: InputBorder.none,
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'email can\'t be empty!'; 
            }
            return null;
          }),
    );
  }
}
