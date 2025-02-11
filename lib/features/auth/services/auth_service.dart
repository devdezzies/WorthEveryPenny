import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/common/widgets/bottom_bar.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/analytics/services/analytics_services.dart';
import 'package:swappp/models/user.dart';
import 'package:swappp/models/subscription.dart'; // Import the Subscription class
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
          username: name,
          email: email,
          subscription: Subscription(
              user: '',
              plan: '',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              createdAt: DateTime.now(),
              updatedAt:
                  DateTime.now()), // Replace with a valid Subscription object
          password: password,
          transactions: [],
          displayName: '',
          bills: [],
          profilePicture: '',
          friends: [],
          friendRequests: [],
          bankAccount: [],
          debts: 0,
          cash: 0,
          monthlyReport: [],
          paymentNumber: '',
          language: 'id',
          currency: 'IDR',
          savings: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          token: '');

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "69420",
        },
      );

      // ignore: use_build_context_synchronously
      if (res.statusCode == 200) {
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
              // ignore: use_build_context_synchronously
              CustomSnackBar.show(context,
                  message: 'Hey welcome!', type: SnackBarType.success);
            },
            onFailure: () {
              // ignore: use_build_context_synchronously
              CustomSnackBar.show(context,
                  message: 'Invalid email or password',
                  type: SnackBarType.error);
            });
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.show(context,
          message: e.toString(), type: SnackBarType.error);
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
          "ngrok-skip-browser-warning": "69420",
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
          },
          onFailure: () {
            // ignore: use_build_context_synchronously
            CustomSnackBar.show(context,
                message: 'Invalid email or password', type: SnackBarType.error);
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      CustomSnackBar.show(context,
          message: e.toString(), type: SnackBarType.error);
    }
  }

  // get user data from local
  Future<void> getUserData(BuildContext context) async {
    final AnalyticsServices analyticsServices = AnalyticsServices();
    try {
      String? token;

      // Use SharedPreferences for mobile
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('x-auth-token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
        token = '';
      }

      var tokenRes = await http
          .post(Uri.parse('$uri/tokenIsValid'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "ngrok-skip-browser-warning": "69420",
        'x-auth-token': token
      });

      var response = jsonDecode(tokenRes.body);
      if (response) {
        // get user data using the API
        http.Response userResponse =
            await http.get(Uri.parse('$uri/'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "69420",
          'x-auth-token': token
        });

        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userResponse.body);
          analyticsServices.getAnalyticsData(context);
        }
      }

      if (context.mounted)
        Provider.of<UserProvider>(context, listen: false).setLoading(false);
    } catch (e) {
      if (context.mounted) {
        debugPrint(e.toString());
      }
    }
  }
}
