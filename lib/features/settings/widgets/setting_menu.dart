import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  final IconData headIcon; 
  final String menuTitle;
  final void Function() onTap;
  const SettingMenu({super.key, required this.headIcon, required this.menuTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(headIcon, size: 30),
          ), 
          Expanded(child: Text(menuTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))), 
          const Icon(Icons.keyboard_arrow_right, size: 30,)
        ],
      ),
    );
  }
}