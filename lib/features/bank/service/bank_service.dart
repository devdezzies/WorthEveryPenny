import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/common/widgets/custom_snackbar.dart';
import 'package:swappp/constants/error_handling.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/auth/services/auth_service.dart';
import 'package:swappp/providers/bank_provider.dart';

class BankService {
  Future<void> addNewBankAccount(BuildContext context) async {
    final BankProvider bankProvider = Provider.of<BankProvider>(context, listen: false);
    final AuthService authService = AuthService();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('x-auth-token');
      debugPrint('Token: $token');

      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token not found'),
            ),
          );
        }
        return;
      }

      http.Response res = await http.post(
        Uri.parse('$uri/bank/addBankAccount'),
        body: bankProvider.bankAccount.toJson(),
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
            bankProvider.resetBankAccount();
            authService.getUserData(context);
            CustomSnackBar.show(context, type: SnackBarType.success, message: 'Added successfully, please refresh the page');
          }, 
          onFailure: () {
            debugPrint(res.body);
            CustomSnackBar.show(context, type: SnackBarType.error, message: 'Failed to add bank account');
          },);
      } else { 
        debugPrint('Context is not mounted');
      }


    } catch (e) {
      // Handle error
      if (context.mounted) {
        CustomSnackBar.show(context, type: SnackBarType.error, message: 'Failed to add bank account');
      }
    }
  }
}
