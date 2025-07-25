import 'dart:convert';

import 'package:swappp/constants/utils.dart';

class BankAccount {
  String user;
  String bankName;
  String accountNumber;
  String accountType;
  double balance;
  List<String> transactions;
  DateTime createdAt;

  BankAccount({
    this.user = '',
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
    required this.balance,
    required this.transactions,
    required this.createdAt,
  });

  // Convert a BankAccount object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'balance': balance,
      'transactions': transactions,
      'createdAt': convertUtcToDateTime(createdAt).toIso8601String()
    };
  }

  // Convert a Map object into a BankAccount object
  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      user: map['user'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      accountType: map['accountType'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
      transactions: List<String>.from(map['transactions'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert a BankAccount object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a BankAccount object
  factory BankAccount.fromJson(String source) => BankAccount.fromMap(json.decode(source));

  // Copy a BankAccount object with new values
  BankAccount copyWith({
    String? user,
    String? bankName,
    String? accountNumber,
    String? accountType,
    double? balance,
    List<String>? transactions,
    DateTime? createdAt,
  }) {
    return BankAccount(
      user: user ?? this.user,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}