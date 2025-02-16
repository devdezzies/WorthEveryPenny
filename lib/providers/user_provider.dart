import 'package:flutter/material.dart';
import 'package:swappp/models/bank_account.dart';
import 'package:swappp/models/bill.dart';
import 'package:swappp/models/friend.dart';
import 'package:swappp/models/monthly_report.dart';
import 'package:swappp/models/subscription.dart';
import 'package:swappp/models/transaction.dart';
import 'package:swappp/models/user.dart';
import 'package:timezone/timezone.dart' as tz;

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    username: '',
    email: '',
    subscription: Subscription(
        user: '',
        plan: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()), // Provide a default Subscription object
    password: '',
    transactions: <Transaction>[],
    displayName: '',
    bills: <Bill>[],
    profilePicture: '',
    friends: <Friend>[],
    friendRequests: <FriendRequest>[],
    bankAccount: <BankAccount>[],
    debts: 0,
    cash: 0,
    monthlyReport: <MonthlyReport>[],
    language: 'id',
    currency: 'IDR',
    paymentNumber: '',
    savings: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    token: '',
    timeZone: tz.getLocation('Asia/Jakarta').toString(),
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

  String getBankNamebyAccountNumber(String accountNumber) {
    if (accountNumber == 'cash') return 'Cash';
    final bankAccount = _user.bankAccount.firstWhere(
      (element) => element.accountNumber == accountNumber
    );
    debugPrint('Bank Name: ${bankAccount.bankName}');
    return bankAccount.bankName;
  }

  void updateUser({
    String? username,
    String? email,
    Subscription? subscription,
    String? password,
    List<Transaction>? transactions,
    String? displayName,
    List<Bill>? bills,
    String? profilePicture,
    List<Friend>? friends,
    List<FriendRequest>? friendRequests,
    List<BankAccount>? bankAccount,
    int? debts,
    int? cash,
    String? paymentNumber,
    List<MonthlyReport>? monthlyReport,
    String? language,
    String? currency,
    int? savings,
    String? token,
    String? timeZone,
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
      timeZone: timeZone ?? _user.timeZone,
    );
    notifyListeners();
  }
}
