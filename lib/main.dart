import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/screens/onboarding.dart';
import 'package:swappp/common/services/preferences_service.dart';
import 'package:swappp/common/screens/bottom_bar.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/analytics_provider.dart';
import 'package:swappp/providers/bank_provider.dart';
import 'package:swappp/providers/preferences_provider.dart';
import 'package:swappp/providers/transaction_provider.dart';
import 'package:swappp/providers/user_provider.dart';
import 'package:swappp/router.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

import 'common/widgets/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
    ChangeNotifierProvider(create: (context) => BankProvider()),
    ChangeNotifierProvider(create: (context) => AnalyticsProvider()),
    ChangeNotifierProvider(create: (context) => PreferencesProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  final PreferencesService preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
    preferencesService.getAllPreferences(context);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return MaterialApp(
            title: "WorthEveryPenny",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: GlobalVariables.backgroundColor,
                splashColor: Colors.transparent,
                fontFamily: 'Satoshi',
                colorScheme: const ColorScheme.dark(
                    primary: GlobalVariables.secondaryColor),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                    color: Colors.green,
                    iconTheme: IconThemeData(color: Colors.black))),
            onGenerateRoute: (settings) => generateRoute(settings),
            home: Provider.of<UserProvider>(context).isLoading
                ? const SplashScreen()
                : Provider.of<UserProvider>(context).user.token.isNotEmpty
                    ? const BottomBar()
                    : const Onboarding());
      },
      maximumSize: const Size(393, 852), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor: GlobalVariables.darkerGreyBackgroundColor,
    );
  }
}
