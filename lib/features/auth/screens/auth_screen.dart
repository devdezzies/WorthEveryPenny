import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/custom_button.dart';
import 'package:swappp/common/widgets/custom_password_textfield.dart';
import 'package:swappp/common/widgets/custom_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/services/auth_service.dart';

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
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<bool> isSelected = <bool>[true, false];
  final List<Auth> authState = <Auth>[Auth.signup, Auth.signin];
  final AuthService authService = AuthService();

  Auth _auth = Auth.signup;

  @override
  void dispose() { // to avoid memory leaks
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(context: context, email: _emailController.text, password: _passwordController.text, name: _nameController.text);
  }

  void signInUser() {
    authService.signInUser(context: context, email: _emailController.text, password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    strutStyle: const StrutStyle(fontFamily: 'Satoshi'),
                    text: const TextSpan(
                        text: 'Know Your ',
                        style: TextStyle(fontSize: 30, fontFamily: 'Satoshi'),
                        children: [
                          TextSpan(
                              text: 'Money ',
                              style: TextStyle(
                                  color: GlobalVariables.secondaryColor,
                                  fontSize: 30,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'in ',
                              style: TextStyle(fontWeight: FontWeight.w300)),
                        ]),
                  ),
                  const Text("One Look",
                      style: TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 30,
                  ),
                  LayoutBuilder(
                      builder: (context, constraint) => ToggleButtons(
                            constraints: BoxConstraints.expand(
                                width: (constraint.maxWidth - 18) / 2),
                            borderWidth: 1.5,
                            borderColor: Colors.white,
                            selectedBorderColor: Colors.white,
                            isSelected: isSelected,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            onPressed: (int index) {
                              setState(() {
                                if (authState[index] != _auth) {
                                  for (int buttonIndex = 0;
                                      buttonIndex < isSelected.length;
                                      buttonIndex++) {
                                    if (buttonIndex == index) {
                                      isSelected[buttonIndex] = true;
                                    } else {
                                      isSelected[buttonIndex] = false;
                                    }
                                  }
                                  _auth = _auth == Auth.signin
                                      ? Auth.signup
                                      : Auth.signin;
                                }
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Login",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )
                            ],
                          )),
                  const SizedBox(
                    height: 25,
                  ),
                  if (_auth == Auth.signup)
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextfield(
                            controller: _nameController,
                            hintText: "Your Name",
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          CustomTextfield(
                            controller: _emailController,
                            hintText: "Your Email",
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          CustomPasswordTextfield(
                              controller: _passwordController,
                              hintText: "Your Password"),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(textTitle: "Sign Up", onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              signUpUser();
                            }
                          }),
                        ],
                      ),
                    ),
                  if (_auth == Auth.signin)
                    Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          CustomTextfield(
                            controller: _emailController,
                            hintText: "Your Email",
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          CustomPasswordTextfield(
                              controller: _passwordController,
                              hintText: "Your Password"),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(textTitle: "Login", onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              signInUser();
                            }
                          }),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
