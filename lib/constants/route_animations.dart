import 'package:flutter/material.dart';

Route createRouteCustom(Widget targetScreen, Offset begin, Offset end, Curve curve) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
