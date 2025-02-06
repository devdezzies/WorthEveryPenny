import 'package:flutter/material.dart';
import 'package:swappp/models/bank_account.dart';
import 'package:swappp/models/bill.dart';
import 'package:swappp/models/friend.dart';
import 'package:swappp/models/monthly_report.dart';
import 'package:swappp/models/subscription.dart';
import 'package:swappp/models/transaction.dart';
import 'package:swappp/models/user.dart';

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

  // void updateTransaction(String transaction) {
  //   final newTransaction = Transaction.fromJson(transaction);
  //   final newTransactions = [newTransaction, ..._user.transactions];

  //   if (newTransaction.source == 'cash') {
  //     final newCash = newTransaction.type == 'income'
  //         ? _user.cash + newTransaction.amount
  //         : _user.cash - newTransaction.amount;

  //     _user = _user.copyWith(
  //       transactions: newTransactions,
  //       cash: newCash,
  //     );
  //   } else {
  //     final bankAccountIndex = _user.bankAccount.indexWhere(
  //       (acc) => acc.accountNumber == newTransaction.source,
  //     );

  //     if (bankAccountIndex == -1) {
  //       debugPrint('Bank account not found: ${newTransaction.source}');
  //       return;
  //     }

  //     final updatedAccounts = List<BankAccount>.from(_user.bankAccount);
  //     final oldAccount = updatedAccounts[bankAccountIndex];

  //     final newBalance = newTransaction.type == 'income'
  //         ? oldAccount.balance + newTransaction.amount
  //         : oldAccount.balance - newTransaction.amount;

  //     updatedAccounts[bankAccountIndex] = oldAccount.copyWith(
  //       balance: newBalance,
  //     );

  //     _user = _user.copyWith(
  //       transactions: newTransactions,
  //       bankAccount: updatedAccounts,
  //     );
  //   }

  //   // update monthly report 
  //   final currentMonth = DateTime.now().month;
  //   final currentYear = DateTime.now().year;
  //   final currentReportIndex = _user.monthlyReport.indexWhere(
  //     (report) => report.month == currentMonth && report.year == currentYear,
  //   );

  //   if (currentReportIndex == -1) {
  //     final newReport = MonthlyReport(
  //       user: _user.id,
  //       totalIncome: newTransaction.type == 'income'
  //           ? newTransaction.amount.toDouble()
  //           : 0.0,
  //       totalExpense: newTransaction.type == 'expense'
  //           ? newTransaction.amount.toDouble()
  //           : 0.0,
  //       month: currentMonth,
  //       year: currentYear,
  //       spendingCategories: [],
  //       recommendations: [],
  //       createdAt: DateTime.now(),
  //     );

  //     _user = _user.copyWith(
  //       monthlyReport: [newReport, ..._user.monthlyReport],
  //     );
  //   } else {
  //     final oldReport = _user.monthlyReport[currentReportIndex];
  //     final newTotalIncome = oldReport.totalIncome +
  //         (newTransaction.type == 'income' ? newTransaction.amount : 0.0);
  //     final newTotalExpense = oldReport.totalExpense +
  //         (newTransaction.type == 'expense' ? newTransaction.amount : 0.0);

  //     final updatedReport = oldReport.copyWith(
  //       totalIncome: newTotalIncome,
  //       totalExpense: newTotalExpense,
  //     );

  //     final updatedReports = List<MonthlyReport>.from(_user.monthlyReport);
  //     updatedReports[currentReportIndex] = updatedReport;
  //     debugPrint('Updated report: $updatedReport');
  //     _user = _user.copyWith(
  //       monthlyReport: updatedReports,
  //     );
  //   }

  //   notifyListeners();
  // }

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
