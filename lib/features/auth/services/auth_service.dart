import 'package:flutter/material.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/models/user.dart';
import 'package:http/http.dart' as http;

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
      httpErrorHandle(response: res, context: context, onSuccess: () {
        showSnackBar(context, 'Hello 👋 ${user.name}');
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, '⚠️ $e.toString()');
    }
  }
}
