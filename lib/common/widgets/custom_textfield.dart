import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscured;
  const CustomTextfield(
      {super.key, required this.controller, required this.hintText, this.obscured = false});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool isObscuredText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: widget.obscured,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            child: isObscuredText ? const Icon(Icons.lock) : const Icon(Icons.remove_red_eye),
            onTap: () { 
              setState(() {
                isObscuredText = !isObscuredText;
              });
            },
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide:
                BorderSide(color: Colors.white, width: 1.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide:
                BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        validator: (val) {});
  }
}
