import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/onboarding_screen.dart';
import 'package:swappp/features/auth/screens/login_screen.dart';
import 'package:swappp/features/survey/screens/survey_screen.dart';

class Onboarding extends StatefulWidget {
  static const String routeName = '/onboarding';
  const Onboarding({super.key});

  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  final _imageFirst = const AssetImage("assets/images/tult.jpeg");
  final _imageSecond = const AssetImage("assets/images/gedung-3.jpeg");
  final _imageThird = const AssetImage("assets/images/daun.jpeg");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_imageFirst, context);
    precacheImage(_imageSecond, context);
    precacheImage(_imageThird, context);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      pages: [
        OnboardingPage(
          image: _imageFirst,
          title: "Welcome to WorthEveryPenny",
          description: "WorthEveryPenny helps you manage your finances and make better financial decisions",
        ),
        OnboardingPage(
          image: _imageSecond,
          title: "Track your expenses",
          description: "Keep track of your expenses and manage your budget",
        ),
        OnboardingPage(
          image: _imageThird,
          title: "Analyze your spending",
          description: "Understand your spending habits and make better financial decisions",
        ),
      ],
      onSignUp: () {
        Navigator.pushNamedAndRemoveUntil(
            context, SurveyScreen.routeName, (route) => false);
      },
      onLogin: () {
        Navigator.pushNamedAndRemoveUntil(
            context, LogInScreen.routeName, (route) => false);
      },
      onHowItWorks: () {},
    );
  }
}
