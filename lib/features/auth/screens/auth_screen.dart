import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_button.dart';
import 'package:swappp/common/widgets/custom_textfield.dart';
import 'package:swappp/constants/global_variables.dart';

enum Auth {
  signin, 
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "The Place where Your Stuff is Valuable!",
                style: TextStyle(
                    color: GlobalVariables.secondaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25,),
              Form(
                key: _signUpFormKey,
                child: Column(
                  children: [
                    CustomTextfield(controller: _nameController, hintText: "Your Name",), 
                    const SizedBox(height: 18,),
                    CustomTextfield(controller: _emailController, hintText: "Your Email",), 
                    const SizedBox(height: 18,),
                    CustomTextfield(controller: _passwordController, hintText: "Your Password",), 
                    const SizedBox(height: 18,), 
                    CustomButton(textTitle: "Sign Up", onTap: () {})
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
