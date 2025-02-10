import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_button.dart';
import 'package:swappp/common/widgets/custom_password_textfield.dart';
import 'package:swappp/common/widgets/custom_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi! It's Nice to Meet You Here",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Let's get you started with your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _nameController,
                        hintText: "Username",
                      ),
                      const SizedBox(height: 18),
                      CustomTextfield(
                        controller: _emailController,
                        hintText: "Your Email",
                      ),
                      const SizedBox(height: 18),
                      CustomPasswordTextfield(
                        controller: _passwordController,
                        hintText: "Your password",
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        textTitle: "Sign Up",
                        onTap: () {
                          if (_signUpFormKey.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text("By signing up, you agree to our "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(" and "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

