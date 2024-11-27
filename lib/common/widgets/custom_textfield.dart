import 'package:flutter/material.dart';

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
    return TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
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
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'email can\'t be empty!'; 
          }
          return null;
        });
  }
}
