import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/features/bank/screens/bank_manager_screen.dart';
import 'package:swappp/features/home/screens/home_screen.dart';
import 'package:swappp/features/auth/screens/auth_screen.dart';
import 'package:swappp/features/transaction/screens/transaction_history.dart';
import 'package:swappp/features/transaction/screens/transaction_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const AuthScreen());

    case HomeScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const HomeScreen());

    case BottomBar.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const BottomBar());
    
    case TransactionScreen.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const TransactionScreen());

    case TransactionHistory.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const TransactionHistory());

    case BankManagerScreen.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const BankManagerScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("404 page not found")),
        ),
      );
  }
}
