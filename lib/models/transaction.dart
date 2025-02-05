import 'dart:convert';
import 'package:swappp/constants/utils.dart';

class Transaction {
  String id = '';
  String user;
  DateTime date;
  String name;
  int amount;
  List<String> tags;
  String type;
  String? description;
  String? category;
  bool recurring;
  String? recurrenceInterval;
  DateTime? nextOccurrence;
  String currency;
  String? source;
  DateTime createdAt;

  Transaction({
    this.id = '',
    this.user = '',
    required this.date,
    required this.name,
    required this.amount,
    required this.tags,
    required this.type,
    this.description,
    this.category,
    this.recurring = false,
    this.recurrenceInterval,
    this.nextOccurrence,
    this.currency = 'Rp',
    this.source,
    required this.createdAt,
  });

  // Convert a Transaction object into a Map object
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': user,
      'date': date.toIso8601String(),
      'name': name,
      'amount': amount,
      'tags': tags,
      'type': type,
      'description': description,
      'category': category,
      'recurring': recurring,
      'recurrenceInterval': recurrenceInterval,
      'nextOccurrence': nextOccurrence,
      'currency': currency,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map object into a Transaction object
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['_id'] ?? '',
      user: map['user'] ?? '',
      date: convertUtcToDateTime(DateTime.parse(map['date'])),
      name: map['name'] ?? '',
      amount: map['amount'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      type: map['type'] ?? '',
      description: map['description'],
      category: map['category'],
      recurring: map['recurring'] ?? false,
      recurrenceInterval: map['recurrenceInterval'],
      nextOccurrence: map['nextOccurrence'] != null ? convertUtcToDateTime(DateTime.parse(map['nextOccurrence'])) : null,
      currency: map['currency'] ?? 'Rp',
      source: map['source'],
      createdAt: convertUtcToDateTime(DateTime.parse(map['createdAt'])),
    );
  }

  // Convert a Transaction object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Transaction object
  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(user: $user, date: $date, name: $name, amount: $amount, tags: $tags, type: $type, description: $description, category: $category, recurring: $recurring, recurrenceInterval: $recurrenceInterval, nextOccurrence: $nextOccurrence, currency: $currency, source: $source, createdAt: $createdAt)';
  }

  Transaction copyWith({
    String? id,
    String? user,
    DateTime? date,
    String? name,
    int? amount,
    List<String>? tags,
    String? type,
    String? description,
    String? category,
    bool? recurring,
    String? recurrenceInterval,
    DateTime? nextOccurrence,
    String? currency,
    String? source,
    DateTime? createdAt,
  }) {
    return Transaction(
      user: user ?? this.user,
      date: date ?? this.date,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      tags: tags ?? this.tags,
      type: type ?? this.type,
      description: description ?? this.description,
      category: category ?? this.category,
      recurring: recurring ?? this.recurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      nextOccurrence: nextOccurrence ?? this.nextOccurrence,
      currency: currency ?? this.currency,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}