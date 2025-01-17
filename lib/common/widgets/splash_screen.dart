import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Center(
        child: Image.asset("assets/images/splash-logo.png", scale: 2,),
      ),
    );
  }
}