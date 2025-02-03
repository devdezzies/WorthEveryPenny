import 'package:flutter/material.dart';

String uri = 'http://104.43.110.108:3000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromARGB(255, 164, 243, 67);
  static const backgroundColor = Color.fromARGB(255, 18, 18, 18);
  static const Color greyBackgroundColor = Color.fromARGB(255, 33, 33, 33);
  static const Color darkerGreyBackgroundColor =
      Color.fromARGB(255, 40, 40, 40);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;
 
}
