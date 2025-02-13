import 'package:flutter/material.dart';
import 'package:swappp/common/screens/onboarding.dart';
import 'package:swappp/common/screens/bottom_bar.dart';
import 'package:swappp/features/analytics/screens/analytics_screen.dart';
import 'package:swappp/features/auth/screens/login_screen.dart';
import 'package:swappp/features/auth/screens/signup_screen.dart';
import 'package:swappp/features/bank/screens/bank_manager_screen.dart';
import 'package:swappp/features/home/screens/home_screen.dart';
import 'package:swappp/features/split-bill/screens/split_bill_screen.dart';
import 'package:swappp/features/survey/screens/survey_screen.dart';
import 'package:swappp/features/transaction/screens/transaction_history.dart';
import 'package:swappp/features/transaction/screens/transaction_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Onboarding.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const Onboarding());

    case SignUpScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const SignUpScreen());

    case LogInScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const LogInScreen());

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
    
    case AnalyticsScreen.routeName: 
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const AnalyticsScreen());

    case SurveyScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const SurveyScreen());

    case SplitBillScreen.routeName:
      return MaterialPageRoute(settings: routeSettings, builder: (_) => const SplitBillScreen());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text("404 page not found")),
        ),
      );
  }
}
