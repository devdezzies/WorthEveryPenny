import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class SettingsService {
  Future<String> createCannyToken({
    required BuildContext context,
    required String id,
    required String name, 
    required String email
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/createCannyToken'), 
        body: jsonEncode({
          "email": email,
          "id": id,
          "name": name,
        }), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body)['body'];
      } else {
        throw Exception("Failed to create canny token");
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, '$e.toString()');
    }
    return "";
  }
}