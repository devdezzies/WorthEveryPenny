import 'package:flutter/material.dart';
import 'package:swappp/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  String _currentNumber = '';

  String get currentNumber => _currentNumber;

  final Transaction _transaction = Transaction(
    amount: 0,
    name: 'Transaction',
    paymentMethod: 'cash',
    tags: [],
    date: DateTime.now(),
    category: '',
    recurring: false,
    description: '',
    type: 'expense',
    createdAt: DateTime.now(),
  );

  Transaction get transaction => _transaction;

  void setTransactionType(String type) {
    _transaction.type = type;
    notifyListeners();
  }

  void setCurrentNumber(String number) {
    _currentNumber = number;
    _transaction.amount = int.parse(number);
    notifyListeners();
  }

  void setTransactionDate(DateTime date) {
    _transaction.date = date;
    notifyListeners();
  }
  
  void resetTransaction() {
    _currentNumber = '';
    _transaction.amount = 0;
    _transaction.name = 'Transaction';
    _transaction.paymentMethod = 'cash';
    _transaction.tags = [];
    _transaction.date = DateTime.now();
    _transaction.category = '';
    _transaction.recurring = false;
    _transaction.description = '';
    _transaction.type = 'expense';
    _transaction.createdAt = DateTime.now();
    notifyListeners();
  }
}