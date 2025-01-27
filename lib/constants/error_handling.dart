import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:swappp/constants/utils.dart';

void httpErrorHandle({required http.Response response, required BuildContext context, required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200: 
      onSuccess(); 
      break;
    case 400: 
      List errors = jsonDecode(response.body)['errors'];
      for (var error in errors) {
        showSnackBar(context, error['msg']);
      }
      break; 
    case 500: 
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default: 
      showSnackBar(context, response.body);
  }
}