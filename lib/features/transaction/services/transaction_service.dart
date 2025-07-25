import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionService {
  final AuthService authService = AuthService();

  Future<void> addTransaction(BuildContext context) async {
    final TransactionProvider transactionProvider =
        context.read<TransactionProvider>();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        return;
      }

      http.Response res = await http.post(
        Uri.parse('$uri/transaction/addNewTransaction'),
        body: transactionProvider.transaction.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "69420",
          'x-auth-token': token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              authService.getUserData(context);
              Future.delayed(
                  const Duration(seconds: 2)); // Add 2-second delay
            },
            onFailure: () {
              CustomSnackBar.show(context,
                  type: SnackBarType.error, message: 'Failed to add transaction');
            });
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context,
            type: SnackBarType.error, message: 'Failed to add transaction');
      }
    }
  }

  Future<void> deleteTransaction(BuildContext context, String transactionId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        return;
      }

      http.Response res = await http.delete(
        Uri.parse('$uri/transaction/deleteTransaction/$transactionId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "69420",
          'x-auth-token': token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              authService.getUserData(context); 
              Future.delayed(
                  const Duration(seconds: 2));
              // Add 2-second delay
            },
            onFailure: () {
              CustomSnackBar.show(context,
                  type: SnackBarType.error, message: 'Failed to delete transaction');
            });
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context,
            type: SnackBarType.error, message: 'Failed to delete transaction');
      }
    }
  }

  Future<void> getCategorizedTransactions(BuildContext context) async {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        return;
      }

      http.Response res = await http.get(
        Uri.parse('$uri/transaction/getCategorizedTransactions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "ngrok-skip-browser-warning": "69420",
          'x-auth-token': token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              transactionProvider
                  .setCategorizedTransactions(jsonDecode(res.body)['data']);
            },
            onFailure: () {
              CustomSnackBar.show(context,
                  type: SnackBarType.error, message: 'Failed to get transactions');
            });
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(context,
            type: SnackBarType.error, message: 'Failed to get transactions');
      }
    }
  }
}
