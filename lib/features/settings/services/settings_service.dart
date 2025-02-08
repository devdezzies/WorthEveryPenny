import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/user_provider.dart';

class SettingsService {
  Future<String> createCannyToken(
      {required BuildContext context,
      required String id,
      required String name,
      required String email}) async {
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
          });

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

  Future<void> updateProfilePicture(
      {required BuildContext context, required String id, required String profilePicture}) async {
    try {
      final cloudinary = CloudinaryPublic("dimpkquac", "profile");

      if (profilePicture.isNotEmpty) {
        final CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(profilePicture),
        );

        if (response.secureUrl.isNotEmpty) {
          http.Response res = await http.put(
            Uri.parse('$uri/updateProfilePicture/$id'),
            body: jsonEncode({
              "profilePicture": response.secureUrl,
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
          );

          if (res.statusCode == 200 && context.mounted) {
            Provider.of<UserProvider>(context, listen: false).updateUser(
              profilePicture: response.secureUrl,
            );
          } else {
            throw Exception("Failed to update profile picture");
          }
        }
      }
    } catch (e) {
      if (context.mounted) showSnackBar(context, '$e.toString()');
    }
  }

  Future<void> updateSettings(
      {required BuildContext context,
      required String name,
      required String id,
      required String paymentNumber}) async {
    try {

      http.Response res = await http.put(Uri.parse('$uri/updateSettings/$id'),
          body: jsonEncode({
            "displayName": name,
            "paymentNumber": paymentNumber,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      if (res.statusCode == 200 && context.mounted) {
        Provider.of<UserProvider>(context, listen: false).updateUser(
            displayName: name,
            paymentNumber: paymentNumber,);
      }
    } catch (e) {
      debugPrint(e.toString()); //showSnackBar(context, '$e.toString()');
    }
  }

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('x-auth-token') ?? '';
    try {
      http.Response res = await http.post(Uri.parse('$uri/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          });

      if (context.mounted) {
        httpErrorHandle(response: res, context: context, onSuccess: () {
          prefs.remove('x-auth-token');
          Navigator.pushReplacementNamed(context, "/auth-screen");
          debugPrint('Successfully Logged out');
        }, 
        onFailure: () {
          debugPrint('Failed to logout');
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
