import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Icon leadingIcon;
  const ProfileButton({super.key, this.onPressed, required this.title, required this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
          color: GlobalVariables.greyBackgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadingIcon,
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 15),
                )),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
            color: Color.fromARGB(255, 73, 70, 70),
          ),
        ],
      ),
    );
  }
}
