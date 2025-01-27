import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String subscription;
  final String password;
  final List<String> transactions;
  final String displayName;
  final List<String> bills;
  final String profilePicture;
  final List<String> friends;
  final List<String> friendRequests;
  final List<String> bankAccount;
  final int debts;
  final int cash;
  final List<String> monthlyReport;
  final String language;
  final String currency;
  final String paymentNumber;
  final int savings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.subscription,
    required this.password,
    required this.transactions,
    required this.displayName,
    required this.bills,
    required this.profilePicture,
    required this.friends,
    required this.friendRequests,
    required this.bankAccount,
    required this.debts,
    required this.cash,
    required this.monthlyReport,
    required this.language,
    required this.currency,
    required this.paymentNumber,
    required this.savings,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'subscription': subscription,
      'password': password,
      'transactions': transactions,
      'displayName': displayName,
      'bills': bills,
      'profilePicture': profilePicture,
      'friends': friends,
      'friendRequests': friendRequests,
      'bankAccount': bankAccount,
      'debts': debts,
      'monthlyReport': monthlyReport,
      'language': language,
      'paymentNumber': paymentNumber,
      'currency': currency,
      'savings': savings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'token': token,
    };
  }

  // Convert a Map object into a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      subscription: map['subscription'] ?? '',
      password: map['password'] ?? '',
      transactions: List<String>.from(map['transactions'] ?? []),
      displayName: map['displayName'] ?? '',
      bills: List<String>.from(map['bills'] ?? []),
      profilePicture: map['profilePicture'] ?? 'https://i.pinimg.com/736x/73/cd/09/73cd09f43b4ca5b2d56c152a79ac5c60.jpg',
      friends: List<String>.from(map['friends'] ?? []),
      friendRequests: List<String>.from(map['friendRequests'] ?? []),
      bankAccount: List<String>.from(map['bankAccount'] ?? []),
      debts: map['debts'] ?? 0,
      cash: map['cash'] ?? 0,
      monthlyReport: List<String>.from(map['monthlyReport'] ?? []),
      paymentNumber: map['paymentNumber'] ?? '',
      language: map['language'] ?? 'id',
      currency: map['currency'] ?? 'IDR',
      savings: map['savings'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      token: map['token'] ?? '',
    );
  }

  // Convert a User object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a User object
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}