import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/features/home/screens/home_screen.dart';
import 'package:swappp/features/auth/screens/auth_screen.dart';
import 'package:swappp/features/settings/screens/setting_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const HomeScreen());

    case BottomBar.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const BottomBar());

    case SettingScreen.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const SettingScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("404 page not found")),
        ),
      );
  }
}
