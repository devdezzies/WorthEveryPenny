import 'dart:convert';
import 'transaction.dart';
import 'monthly_report.dart';
import 'subscription.dart';
import 'bank_account.dart';
import 'bill.dart';
import 'friend.dart';
class User {
  final String id;
  final String username;
  final String email;
  final Subscription subscription;
  final String password;
  final List<Transaction> transactions;
  final String displayName;
  final List<Bill> bills;
  final String profilePicture;
  final List<Friend> friends;
  final List<FriendRequest> friendRequests;
  final List<BankAccount> bankAccount;
  final int debts;
  final int cash;
  final List<MonthlyReport> monthlyReport;
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
      'subscription': subscription.toMap(),
      'password': password,
      'transactions': transactions,
      'displayName': displayName,
      'bills': bills.map((x) => x.toMap()).toList(),
      'profilePicture': profilePicture,
      'friends': friends.map((x) => x.toMap()).toList(),
      'friendRequests': friendRequests.map((x) => x.toMap()).toList(),
      'bankAccount': bankAccount.map((x) => x.toMap()).toList(),
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
      subscription: map['subscription'] != null ? Subscription.fromMap(map['subscription']) : Subscription(
        user: '', 
        plan: '',  
        startDate: DateTime.now(), 
        endDate: DateTime.now(), 
        createdAt: DateTime.now(), 
        updatedAt: DateTime.now()
      ),
      password: map['password'] ?? '',
      transactions: List<Transaction>.from(map['transactions']?.map((x) => Transaction.fromMap(x)) ?? []),
      displayName: map['displayName'] ?? '',
      bills: List<Bill>.from(map['bills']?.map((x) => Bill.fromMap(x)) ?? []),
      profilePicture: map['profilePicture'] ?? 'https://i.pinimg.com/736x/73/cd/09/73cd09f43b4ca5b2d56c152a79ac5c60.jpg',
      friends: List<Friend>.from(map['friends']?.map((x) => Friend.fromMap(x)) ?? []),
      friendRequests: List<FriendRequest>.from(map['friendRequests']?.map((x) => FriendRequest.fromMap(x)) ?? []),
      bankAccount: List<BankAccount>.from(map['bankAccount']?.map((x) => BankAccount.fromMap(x)) ?? []),
      debts: map['debts'] ?? 0,
      cash: map['cash'] ?? 0,
      monthlyReport: List<MonthlyReport>.from(map['monthlyReport']?.map((x) => MonthlyReport.fromMap(x)) ?? []),
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