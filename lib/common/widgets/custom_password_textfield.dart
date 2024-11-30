import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class CustomPasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const CustomPasswordTextfield({super.key, required this.controller, required this.hintText});

  @override
  State<CustomPasswordTextfield> createState() => _CustomPasswordTextfieldState();
}

class _CustomPasswordTextfieldState extends State<CustomPasswordTextfield> {
  bool isObscuredText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: isObscuredText,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isObscuredText ? const Icon(Icons.visibility, color: GlobalVariables.secondaryColor,) : const Icon(Icons.visibility_off),
            ),
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
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'password can\'t be empty';
          }
          return null;
        });
  }
}
