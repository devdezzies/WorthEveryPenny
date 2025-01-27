import 'package:flutter/material.dart';
import 'package:swappp/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    username: '',
    email: '',
    subscription: '',
    password: '',
    transactions: [],
    displayName: '',
    bills: [],
    profilePicture: '',
    friends: [],
    friendRequests: [],
    bankAccount: [],
    debts: 0,
    cash: 0,
    monthlyReport: [],
    language: 'id',
    currency: 'IDR',
    paymentNumber: '',
    savings: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    token: '',
  );

  bool _isLoading = true;

  User get user => _user;
  bool get isLoading => _isLoading;

  void setUser(String user) {
    _user = User.fromJson(user); 
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateUser({
    String? username,
    String? email,
    String? subscription,
    String? password,
    List<String>? transactions,
    String? displayName,
    List<String>? bills,
    String? profilePicture,
    List<String>? friends,
    List<String>? friendRequests,
    List<String>? bankAccount,
    int? debts,
    int? cash,
    String? paymentNumber,
    List<String>? monthlyReport,
    String? language,
    String? currency,
    int? savings,
    String? token,
  }) {
    _user = User(
      id: _user.id,
      username: username ?? _user.username,
      email: email ?? _user.email,
      subscription: subscription ?? _user.subscription,
      password: password ?? _user.password,
      transactions: transactions ?? _user.transactions,
      displayName: displayName ?? _user.displayName,
      bills: bills ?? _user.bills,
      profilePicture: profilePicture ?? _user.profilePicture,
      friends: friends ?? _user.friends,
      friendRequests: friendRequests ?? _user.friendRequests,
      bankAccount: bankAccount ?? _user.bankAccount,
      debts: debts ?? _user.debts,
      cash: cash ?? _user.cash,
      paymentNumber: paymentNumber ?? _user.paymentNumber,
      monthlyReport: monthlyReport ?? _user.monthlyReport,
      language: language ?? _user.language,
      currency: currency ?? _user.currency,
      savings: savings ?? _user.savings,
      createdAt: _user.createdAt,
      updatedAt: DateTime.now(),
      token: token ?? _user.token,
    );
    notifyListeners();
  }
}
