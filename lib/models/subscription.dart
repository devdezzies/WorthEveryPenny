import 'dart:convert';

import 'package:swappp/constants/utils.dart';

class Subscription {
  String user;
  String plan;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  Subscription({
    required this.user,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a Subscription object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'plan': plan,
      'startDate': convertUtcToDateTime(startDate).toIso8601String(),
      'endDate': convertUtcToDateTime(endDate).toIso8601String(),
      'createdAt': convertUtcToDateTime(createdAt).toIso8601String(),
      'updatedAt': convertUtcToDateTime(updatedAt).toIso8601String(),
    };
  }

  // Convert a Map object into a Subscription object
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      user: map['user'] ?? '',
      plan: map['plan'] ?? 'Basic',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Convert a Subscription object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Subscription object
  factory Subscription.fromJson(String source) => Subscription.fromMap(json.decode(source));
}