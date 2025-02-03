import 'dart:convert';

import 'package:swappp/constants/utils.dart';

class SpendingCategory {
  String category;
  double amount;

  SpendingCategory({
    required this.category,
    required this.amount,
  });

  // Convert a SpendingCategory object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'amount': amount,
    };
  }

  // Convert a Map object into a SpendingCategory object
  factory SpendingCategory.fromMap(Map<String, dynamic> map) {
    return SpendingCategory(
      category: map['category'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Convert a SpendingCategory object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a SpendingCategory object
  factory SpendingCategory.fromJson(String source) => SpendingCategory.fromMap(json.decode(source));
}

class MonthlyReport {
  String user;
  double totalIncome;
  double totalExpense;
  int month;
  int year;
  List<SpendingCategory> spendingCategories;
  List<String> recommendations;
  DateTime createdAt;

  MonthlyReport({
    required this.user,
    required this.totalIncome,
    required this.totalExpense,
    required this.month,
    required this.year,
    required this.spendingCategories,
    required this.recommendations,
    required this.createdAt,
  });

  // Convert a MonthlyReport object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'month': month,
      'year': year,
      'spendingCategories': spendingCategories.map((x) => x.toMap()).toList(),
      'recommendations': recommendations,
      'createdAt': convertUtcToDateTime(createdAt).toIso8601String(),
    };
  }

  // Convert a Map object into a MonthlyReport object
  factory MonthlyReport.fromMap(Map<String, dynamic> map) {
    return MonthlyReport(
      user: map['user'] ?? '',
      totalIncome: map['totalIncome']?.toDouble() ?? 0.0,
      totalExpense: map['totalExpense']?.toDouble() ?? 0.0,
      month: map['month'] ?? 1,
      year: map['year'] ?? DateTime.now().year,
      spendingCategories: List<SpendingCategory>.from(
        map['spendingCategories']?.map((x) => SpendingCategory.fromMap(x)) ?? [],
      ),
      recommendations: List<String>.from(map['recommendations'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert a MonthlyReport object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a MonthlyReport object
  factory MonthlyReport.fromJson(String source) => MonthlyReport.fromMap(json.decode(source));
}