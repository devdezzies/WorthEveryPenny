import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/transaction_provider.dart';

class TransactionService {
  void addTransaction(BuildContext context) async {
    final TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    final AuthService authService = AuthService();
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
          'x-auth-token': token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              transactionProvider.resetTransaction();
              // TODO: THERE MIGHT BE A BETTER WAY TO DO THIS
              authService.getUserData(context);
            });
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, '⚠️ $e.toString()');
      }
    }
  }

  void getCategorizedTransactions(BuildContext context) async {
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
          'x-auth-token': token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              transactionProvider.setCategorizedTransactions(
                  jsonDecode(res.body)['data']);
              debugPrint(transactionProvider.fetchedCategorizedTransactions
                  .toString());   
            });
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, '⚠️ $e.toString()');
      }
    }
  }
}
