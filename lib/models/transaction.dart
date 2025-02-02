import 'dart:convert';

class Transaction {
  String user;
  DateTime date;
  String name;
  int amount;
  List<String> tags;
  String type;
  String? description;
  String? category;
  bool recurring;
  String currency;
  String? source;
  DateTime createdAt;

  Transaction({
    this.user = '',
    required this.date,
    required this.name,
    required this.amount,
    required this.tags,
    required this.type,
    this.description,
    this.category,
    this.recurring = false,
    this.currency = 'Rp',
    this.source,
    required this.createdAt,
  });

  // Convert a Transaction object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
      'tags': tags,
      'type': type,
      'description': description,
      'category': category,
      'recurring': recurring,
      'currency': currency,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map object into a Transaction object
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      user: map['user'] ?? '',
      date: DateTime.parse(map['date']),
      name: map['name'] ?? '',
      amount: map['amount'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      type: map['type'] ?? '',
      description: map['description'],
      category: map['category'],
      recurring: map['recurring'] ?? false,
      currency: map['currency'] ?? 'Rp',
      source: map['source'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert a Transaction object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Transaction object
  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));
}