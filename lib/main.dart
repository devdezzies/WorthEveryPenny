import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/screens/auth_screen.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/bank_provider.dart';
import 'package:swappp/providers/transaction_provider.dart';
import 'package:swappp/providers/user_provider.dart';
import 'package:swappp/router.dart';

import 'common/widgets/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()), 
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
    ChangeNotifierProvider(create: (context) => BankProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: "WorthEveryPenny",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            splashColor: Colors.transparent,
            fontFamily: 'Satoshi',
            colorScheme: const ColorScheme.dark(
              primary: GlobalVariables.secondaryColor,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              color: Colors.green,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          onGenerateRoute: (settings) => generateRoute(settings),
          home: Builder(
            builder: (context) {
              final userProvider = Provider.of<UserProvider>(context);
              if (userProvider.isLoading) {
                return const SplashScreen();
              } else if (userProvider.user.token.isNotEmpty) {
                return const BottomBar();
              } else {
                return const AuthScreen();
              }
            },
          ),
        );
      },
    );
  }
}
