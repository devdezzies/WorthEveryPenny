import 'package:flutter/material.dart';
import 'package:swappp/models/bank_account.dart';

class BankProvider extends ChangeNotifier {
    final BankAccount _bankAccount = BankAccount(
        bankName: '', 
        accountNumber: '',
        accountType: 'Debit',
        balance: 0.0,
        transactions: [],
        createdAt: DateTime.now(),
    );

    BankAccount get bankAccount => _bankAccount;

    void setBankAccountDetails({String? bankName, String? accountNumber, double balance = 0.0}) {
        if (bankName != null) {
            _bankAccount.bankName = bankName;
        }
        if (accountNumber != null) {
            _bankAccount.accountNumber = accountNumber;
        }
        _bankAccount.balance = balance;
        notifyListeners();
    }

    void setBalance(double balance) {
        _bankAccount.balance = balance;
        notifyListeners();
    }

    void setTransactions(List<String> transactions) {
        _bankAccount.transactions = transactions;
        notifyListeners();
    }

    void resetBankAccount() {
        _bankAccount.bankName = '';
        _bankAccount.accountNumber = '';
        _bankAccount.accountType = 'Debit';
        _bankAccount.balance = 0.0;
        _bankAccount.transactions = [];
        _bankAccount.createdAt = DateTime.now();
        notifyListeners();
    }
}