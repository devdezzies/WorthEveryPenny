import 'package:flutter/material.dart';
import 'package:swappp/features/auth/home/screens/home_screen.dart';
import 'package:swappp/features/auth/screens/auth_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const HomeScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("404 page not found")),
        ),
      );
  }
}
