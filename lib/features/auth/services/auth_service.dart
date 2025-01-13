import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:swappp/providers/user_provider.dart';

class AuthService {
  // SIGN UP USER
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
          id: '',
          name: name,
          password: password,
          address: '',
          type: '',
          token: '',
          email: email);

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Hello 👋 ${user.name}');
            });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, '⚠️ $e.toString()');
    }
  }

  // SIGN IN USER
  void signInUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          // ignore: use_build_context_synchronously
          context: context,
          onSuccess: () async {
            // save the token on user's device
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (context.mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(res.body);
            }
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, (route) => false);
            }
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, '⚠️ $e.toString()');
    }
  }

  // get user data from local
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);
      if (response) {
        // get user data using the API
        http.Response userResponse = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userResponse.body);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, '⚠️ $e.toString()');
      }
    }
  }
}
