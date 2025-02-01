import 'package:flutter/material.dart';

class UserDataForm extends StatelessWidget {
  final String headContent; 
  final String content;

  const UserDataForm({super.key, required this.headContent, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headContent,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        Text(
          content,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey[500]),
        )
      ],
    );
  }
}
