import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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

  Future<void> updateSettings(
      {required BuildContext context,
      required String name,
      required String id,
      required String paymentNumber,
      required String profilePicture}) async {
    final cloudinary = CloudinaryPublic("dimpkquac", "profile");

    final String currentUserProfilePicture =
        Provider.of<UserProvider>(context, listen: false).user.profilePicture;

    try {
      if (profilePicture.isNotEmpty) {
        final CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(profilePicture),
        );

        if (response.secureUrl.isNotEmpty) {
          profilePicture = response.secureUrl;
        }
      }

      http.Response res = await http.put(Uri.parse('$uri/updateSettings/$id'),
          body: jsonEncode({
            "displayName": name,
            "paymentNumber": paymentNumber,
            "profilePicture": profilePicture == ""
                ? currentUserProfilePicture
                : profilePicture, 
            
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          });

      if (res.statusCode == 200 && context.mounted) {
        Provider.of<UserProvider>(context, listen: false).updateUser(
            displayName: name,
            profilePicture: profilePicture == ""
                ? currentUserProfilePicture
                : profilePicture,
            paymentNumber: paymentNumber);
      }
    } catch (e) {
      debugPrint(e.toString()); //showSnackBar(context, '$e.toString()');
    }
  }
}
