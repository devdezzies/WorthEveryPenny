import 'package:flutter/material.dart';
import 'package:swappp/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  String _currentNumber = '';

  String get currentNumber => _currentNumber;

  final Transaction _transaction = Transaction(
    amount: 0,
    name: 'Transaction',
    source: 'cash',
    tags: [],
    date: DateTime.now(),
    category: 'Utilities',
    recurring: false,
    description: '',
    type: 'expense',
    createdAt: DateTime.now(),
  );

  final List<dynamic> _fetchedCategorizedTransactions = [];

  Transaction get transaction => _transaction;
  List<dynamic> get fetchedCategorizedTransactions => _fetchedCategorizedTransactions;

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
  
  void setSource(String source) {
    _transaction.source = source;
    notifyListeners();
  }
  
  void resetTransaction() {
    _currentNumber = '';
    _transaction.amount = 0;
    _transaction.name = 'Transaction';
    _transaction.source = 'cash';
    _transaction.tags = [];
    _transaction.date = DateTime.now();
    _transaction.category = 'Utilities';
    _transaction.recurring = false;
    _transaction.description = '';
    _transaction.type = 'expense';
    _transaction.createdAt = DateTime.now();
    notifyListeners();
  }

  void setCategorizedTransactions(List<dynamic> transactions) {
    _fetchedCategorizedTransactions.clear();
    _fetchedCategorizedTransactions.addAll(transactions);
    notifyListeners();
  }
}