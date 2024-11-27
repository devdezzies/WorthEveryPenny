import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Satoshi'),), backgroundColor: GlobalVariables.secondaryColor,));
}