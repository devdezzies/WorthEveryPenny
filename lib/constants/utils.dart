import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/models/user.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        fontFamily: 'Satoshi',
      ),
    ),
    backgroundColor: GlobalVariables.secondaryColor,
  ));
}

Future<String?> pickImageFromCamera() async {
  try {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

Future<String?> pickImageFromGallery() async {
  try {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

String rupiahFormatCurrency(int value) {
  return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00";
}

String countTimeAgo(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 0) {
    return "${diff.inDays} days ago";
  } else if (diff.inHours > 0) {
    return "${diff.inHours} hours ago";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} minutes ago";
  } else {
    return "${diff.inSeconds} seconds ago";
  }
}

int getGrowthPercentage(int totalBalance, int previousTotalBalance) {
  final double growth =
      (totalBalance - previousTotalBalance) / previousTotalBalance * 100;
  return growth.toInt();
}

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

String monthName(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "";
  }
}

final List<Map<String, String>> categories = [
  {"title": "Food and Beverages", "emoji": "😋"},
  {"title": "Transportation", "emoji": "🚗"},
  {"title": "Shopping", "emoji": "🛍️"},
  {"title": "Entertainment", "emoji": "🎬"},
  {"title": "Health and Fitness", "emoji": "🏋️"},
  {"title": "Travel", "emoji": "✈️"},
  {"title": "Education", "emoji": "📚"},
  {"title": "Utilities", "emoji": "📦"},
  {"title": "Housing", "emoji": "🏠"},
  {"title": "Insurance", "emoji": "🛡️"},
];

String getCategoryEmoji(String category) {
  for (var item in categories) {
    if (item["title"] == category) {
      return item["emoji"] ?? "🛒";
    }
  }
  return "🛒";
}

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Format time in 12-hour with AM/PM
  final hour = dateTime.hour;
  final period = hour >= 12 ? 'PM' : 'AM';
  int twelveHour = hour % 12;
  twelveHour = twelveHour == 0 ? 12 : twelveHour; // Handle 0 (midnight) as 12 AM
  final formattedHour = twelveHour.toString().padLeft(2, '0');
  final formattedMinute = dateTime.minute.toString().padLeft(2, '0');
  final time = '$formattedHour:$formattedMinute $period';

  if (inputDate == today) {
    return 'Today, $time';
  } else if (inputDate == yesterday) {
    return 'Yesterday, $time';
  } else {
    return '${dateTime.day} ${monthName(dateTime.month)}, $time';
  }
}

int growthPercentageIncomeByPreviousDay(User user) {
  if (user.transactions.isEmpty) return 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  // 1. Null-check transactions
  final transactions = user.transactions;
  if (transactions.isEmpty) return 0;

  // 2. Safe date comparison helper
  bool isSameDate(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 3. Safely filter valid transactions
  final validTransactions = transactions.where((t) => 
    t.type == 'income'
  ).toList();

  // 4. Get daily totals safely
  final todayTotal = validTransactions
    .where((t) => isSameDate(t.date, today))
    .fold<int>(0, (sum, t) => sum + (t.amount));

  final yesterdayTotal = validTransactions
    .where((t) => isSameDate(t.date, yesterday))
    .fold<int>(0, (sum, t) => sum + (t.amount));

  // 5. Handle edge cases
  if (todayTotal == 0 && yesterdayTotal == 0) return 0;
  if (yesterdayTotal == 0) return todayTotal > 0 ? 100 : 0;

  // 6. Calculate percentage safely
  final percentage = ((todayTotal - yesterdayTotal) / yesterdayTotal * 100).round();
  return percentage.clamp(-100, double.infinity).toInt();
}

int growthPercentageExpenseByPreviousDay(User user) {
  if (user.transactions.isEmpty) return 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  // 1. Null-check transactions
  final transactions = user.transactions;
  if (transactions.isEmpty) return 0;

  // 2. Safe date comparison helper
  bool isSameDate(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 3. Safely filter valid transactions
  final validTransactions = transactions.where((t) => 
    t.type == 'expense'
  ).toList();

  // 4. Get daily totals safely
  final todayTotal = validTransactions
    .where((t) => isSameDate(t.date, today))
    .fold<int>(0, (sum, t) => sum + (t.amount));

  final yesterdayTotal = validTransactions
    .where((t) => isSameDate(t.date, yesterday))
    .fold<int>(0, (sum, t) => sum + (t.amount));

  // 5. Handle edge cases
  if (todayTotal == 0 && yesterdayTotal == 0) return 0;
  if (yesterdayTotal == 0) return todayTotal > 0 ? 100 : 0;

  // 6. Calculate percentage safely
  final percentage = ((todayTotal - yesterdayTotal) / yesterdayTotal * 100).round();
  return percentage.clamp(-100, double.infinity).toInt();
}