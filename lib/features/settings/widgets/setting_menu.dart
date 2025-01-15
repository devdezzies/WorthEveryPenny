import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class SettingMenu extends StatelessWidget {
  final IconData headIcon; 
  final String menuTitle;
  final String? previewTitle;
  final void Function() onTap;
  const SettingMenu({super.key, required this.headIcon, required this.menuTitle, required this.onTap, this.previewTitle});

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
          if (previewTitle != null) 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: GlobalVariables.secondaryColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(previewTitle ?? "", style: const TextStyle(fontWeight: FontWeight.w700, color: GlobalVariables.backgroundColor)),
            ),
          const Icon(Icons.keyboard_arrow_right, size: 30,)
        ],
      ),
    );
  }
}