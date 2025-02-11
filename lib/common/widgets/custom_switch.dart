import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class CustomToggleSwitch extends StatefulWidget {
  final void Function(bool) onToggle;
  const CustomToggleSwitch({super.key, required this.onToggle});

  @override
  CustomToggleSwitchState createState() => CustomToggleSwitchState();
}

class CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalVariables.darkerGreyBackgroundColor.withAlpha(200),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggleButton(
              text: 'Income',
              isSelected: isIncome,
              onTap: () => setState(() {
                isIncome = true;
                widget.onToggle(true);
              }),
            ),
            _buildToggleButton(
              text: 'Expense',
              isSelected: !isIncome,
              onTap: () => setState(() {
                isIncome = false;
                widget.onToggle(false);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9FFF00) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? GlobalVariables.darkerGreyBackgroundColor : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}