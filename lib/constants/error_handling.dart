import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swappp/common/widgets/custom_snackbar.dart';

/// Handles HTTP errors based on the response status code.
/// Displays appropriate error messages using SnackBars and calls success or failure callbacks.
void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  required VoidCallback onFailure,
}) {
  try {
    switch (response.statusCode) {
      case 200:
        // If the response is successful, call the success callback.
        onSuccess();
        break;
      case 400:
        // If the response indicates a bad request, decode the errors and show them.
        List errors = jsonDecode(response.body)['errors'];
        for (var error in errors) {
          CustomSnackBar.show(context, type: SnackBarType.error, message: error);
        }
        // Call failure callback
        onFailure();
        break;
      case 500:
        // If the response indicates a server error, decode and show the error message.
        CustomSnackBar.show(context, type: SnackBarType.error, message: jsonDecode(response.body)['error']);
        // Call failure callback
        onFailure();
        break;
      default:
        // For any other status code, show the response body as the error message.
        CustomSnackBar.show(context, type: SnackBarType.error, message: response.body);
        // Call failure callback
        onFailure();
    }
  } catch (e) {
    // Handle any errors that occur during JSON decoding or other operations.
    debugPrint('Error handling HTTP response: $e');
    // Call failure callback
    onFailure();
  }
}