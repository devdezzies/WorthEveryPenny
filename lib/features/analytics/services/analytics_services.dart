import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/analytics_provider.dart';
import 'package:http/http.dart' as http;

class AnalyticsServices {
  Future<void> getAnalyticsData(BuildContext context) async {
    final AnalyticsProvider analyticsProvider = Provider.of<AnalyticsProvider>(context, listen: false);

    try {
      String? token; 

      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('x-auth-token');
      if (token == null) return; 

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "ngrok-skip-browser-warning": "69420",
            'x-auth-token': token
          });
      
      var response = jsonDecode(tokenRes.body);
      if (response) {
        http.Response analyticsResponse = await http.get(Uri.parse('$uri/transaction/getDailyAmountTransactions'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              "ngrok-skip-browser-warning": "69420",
              'x-auth-token': token
            });

        analyticsProvider.setIncomeData(jsonDecode(analyticsResponse.body)['data']);
        analyticsProvider.setExpenseData(jsonDecode(analyticsResponse.body)['data']);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, '⚠️ $e.toString()');
      }
    }
  }
}