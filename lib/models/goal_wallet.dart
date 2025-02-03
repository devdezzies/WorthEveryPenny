import 'dart:convert';

import 'package:swappp/constants/utils.dart';

class GoalWallet {
  String user;
  String goalName;
  double targetAmount;
  double currentAmount;
  DateTime? targetDate;
  DateTime createdAt;
  DateTime updatedAt;

  GoalWallet({
    required this.user,
    required this.goalName,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.targetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a GoalWallet object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'goalName': goalName,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': convertUtcToDateTime(targetDate ?? DateTime.now()).toIso8601String(),
      'createdAt': convertUtcToDateTime(createdAt).toIso8601String(),
      'updatedAt': convertUtcToDateTime(updatedAt).toIso8601String(),
    };
  }

  // Convert a Map object into a GoalWallet object
  factory GoalWallet.fromMap(Map<String, dynamic> map) {
    return GoalWallet(
      user: map['user'] ?? '',
      goalName: map['goalName'] ?? '',
      targetAmount: map['targetAmount']?.toDouble() ?? 0.0,
      currentAmount: map['currentAmount']?.toDouble() ?? 0.0,
      targetDate: map['targetDate'] != null ? DateTime.parse(map['targetDate']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Convert a GoalWallet object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a GoalWallet object
  factory GoalWallet.fromJson(String source) => GoalWallet.fromMap(json.decode(source));
}