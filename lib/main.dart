import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/screens/auth_screen.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/user_provider.dart';
import 'package:swappp/router.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider())
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
    return MaterialApp(
      title: "swappp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          fontFamily: 'Satoshi',
          colorScheme:
              const ColorScheme.dark(primary: GlobalVariables.secondaryColor),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              color: Colors.green,
              iconTheme: IconThemeData(color: Colors.black))),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty ? const BottomBar() : const AuthScreen()
    );
  }
}
