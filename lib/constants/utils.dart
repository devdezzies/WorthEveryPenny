import 'dart:math';

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
  return growth.round();
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

int growthPercentageIncome(User user) {
  const analysisWindow = 21;
  const maxPercentage = 100;
  final now = DateTime.now();
  
  // 1. Safe temporal segmentation
  final dailyIncome = <DateTime, double>{};
  final cutoff = now.subtract(const Duration(days: analysisWindow * 2));
  final todayDate = DateTime(now.year, now.month, now.day);

  // 2. Null-safe transaction processing
  final validTransactions = (user.transactions)
      .where((t) => t.type == 'income')
      .where((t) => t.date.isAfter(cutoff))
      .toList();

  // 3. Safe date population with fallbacks
  for (var i = 0; i < analysisWindow * 2; i++) {
    final date = todayDate.subtract(Duration(days: i));
    dailyIncome[date] = 0.0;
  }

  // 4. Null-protected aggregation
  for (final t in validTransactions) {
    final date = DateTime(t.date.year, t.date.month, t.date.day);
    final amount = t.amount;
    dailyIncome[date] = (dailyIncome[date] ?? 0) + amount;
  }

  // 5. Safe statistical calculations
  final recentValues = dailyIncome.values
      .take(analysisWindow)
      .where((v) => v > 0)
      .toList();

  if (recentValues.isEmpty) return 0;

  final historicalMean = recentValues.average;
  final historicalStdDev = recentValues.standardDeviation;
  final currentIncome = dailyIncome[todayDate] ?? 0;

  // 6. Adaptive normalization with fallbacks
  final safeUpperBand = historicalMean + (2 * historicalStdDev);
  final safeLowerBand = max(0, historicalMean - (2 * historicalStdDev));
  final bandRange = safeUpperBand - safeLowerBand;

  // 7. Null-safe difference calculation
  final rawDifference = currentIncome - historicalMean;
  final normalizedGrowth = bandRange > 0 
      ? rawDifference / bandRange 
      : 0;

  // 8. Protected sigmoid transform
  final sigmoidGrowth = 1 / (1 + exp(-normalizedGrowth * 3));

  // 9. Confidence factors with defaults
  final completenessFactor = min(1, validTransactions.length / 14);
  final volatilityFactor = historicalMean > 0 
      ? 1 - min(1, historicalStdDev / historicalMean)
      : 1;

  // 10. Final safeguarded calculation
  final finalScore = sigmoidGrowth *
                     completenessFactor *
                     volatilityFactor *
                     maxPercentage;

  return finalScore.clamp(0, maxPercentage).round();
}

// Enhanced null-safe extensions
extension StatList on List<double> {
  double get average {
    if (isEmpty) return 0;
    return reduce((a, b) => a + b) / length;
  }
  
  double get standardDeviation {
    if (length < 2) return 0;
    final mean = average;
    final variance = fold<double>(0, (sum, x) => sum + pow(x - mean, 2)) / length;
    return sqrt(variance);
  }
}

int growthPercentageExpense(User user) {
  const analysisWindow = 21;
  const maxPercentage = 100;
  final now = DateTime.now();
  
  // 1. Safe temporal segmentation
  final dailyExpense = <DateTime, double>{};
  final cutoff = now.subtract(const Duration(days: analysisWindow * 2));
  final todayDate = DateTime(now.year, now.month, now.day);

  // 2. Null-safe transaction processing
  final validTransactions = (user.transactions)
      .where((t) => t.type == 'expense')
      .where((t) => t.date.isAfter(cutoff))
      .toList();

  // 3. Safe date population with fallbacks
  for (var i = 0; i < analysisWindow * 2; i++) {
    final date = todayDate.subtract(Duration(days: i));
    dailyExpense[date] = 0.0;
  }

  // 4. Null-protected aggregation
  for (final t in validTransactions) {
    final date = DateTime(t.date.year, t.date.month, t.date.day);
    final amount = t.amount;
    dailyExpense[date] = (dailyExpense[date] ?? 0) + amount;
  }

  // 5. Safe statistical calculations
  final recentValues = dailyExpense.values
      .take(analysisWindow)
      .where((v) => v > 0)
      .toList();

  if (recentValues.isEmpty) return 0;

  final historicalMean = recentValues.average;
  final historicalStdDev = recentValues.standardDeviation;
  final currentExpense = dailyExpense[todayDate] ?? 0;

  // 6. Adaptive normalization with fallbacks
  final safeUpperBand = historicalMean + (2 * historicalStdDev);
  final safeLowerBand = max(0, historicalMean - (2 * historicalStdDev));
  final bandRange = safeUpperBand - safeLowerBand;

  // 7. Null-safe difference calculation
  final rawDifference = currentExpense - historicalMean;
  final normalizedGrowth = bandRange > 0 
      ? rawDifference / bandRange 
      : 0;

  // 8. Protected sigmoid transform
  final sigmoidGrowth = 1 / (1 + exp(-normalizedGrowth * 3));

  // 9. Confidence factors with defaults
  final completenessFactor = min(1, validTransactions.length / 14); 
  final volatilityFactor = historicalMean > 0 
      ? 1 - min(1, historicalStdDev / historicalMean)
      : 1;

  // 10. Final safeguarded calculation
  final finalScore = sigmoidGrowth *
                     completenessFactor *
                     volatilityFactor *
                     maxPercentage;

  return finalScore.clamp(0, maxPercentage).round();
}

class GradientIntensityMeter extends StatelessWidget {
  final double value; // Value between 0 and 100
  final double width;
  final double height;

  const GradientIntensityMeter({
    super.key,
    required this.value,
    this.width = 60,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00FFBB),
            Color(0xFFFFFF00),
            Color(0xFFFF3434),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow the pointer to extend outside the bar
        children: [
          Positioned(
            left: (value / 100) * width - 2, // Centering the pointer
            top: -10, // Extend above the bar
            bottom: -10, // Extend below the bar
            child: Center(
              child: Container(
                width: 4,
                height: height + 10, // Increased height of the pointer
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


double calculateFinancialHealth(User user) {
  // 1. Data preprocessing
  final transactions = user.transactions;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expenses = transactions
      .where((t) => t.type == 'expense' && t.date.isBefore(today.add(const Duration(days: 1))))
      .toList();

  // 2. Edge case handling
  if (expenses.isEmpty) return 0.0; // Perfect score for no expenses
  if (expenses.every((e) => e.date.isAtSameMomentAs(today))) return 100.0; // First day

  // 3. Time-weighted statistics
  final (double mean, double stdDev) = _calculateWeightedStats(user, today);
  final todayTotal = _sumTodayExpenses(user, today);

  // 4. Bayesian inference for sparse data
  final dataQuality = _calculateDataQuality(user, today);
  final adjustedMean = dataQuality * mean + (1 - dataQuality) * _defaultPrior(user);

  // 5. Volatility-normalized score
  final zScore = (todayTotal - adjustedMean) / (stdDev + 1e-10);
  final normalizedScore = 1 / (1 + exp(-zScore * 1.5)); // Sigmoid function

  // 6. Momentum adjustment
  final momentum = _calculateTrendMomentum(user, today);
  
  return ((normalizedScore * 0.7 + momentum * 0.3) * 100)
      .clamp(0, 100)
      .toDouble();
}

// Helper functions
(double, double) _calculateWeightedStats(User user, DateTime today) {
  final expenses = user.transactions;
  const decayRate = 0.9; // 10% daily decay
  double sum = 0.0, sumSquares = 0.0, totalWeight = 0.0;

  for (final e in expenses) {
    final daysOld = today.difference(e.date).inDays;
    final weight = pow(decayRate, daysOld).toDouble();
    final amount = e.amount;

    sum += amount * weight;
    sumSquares += amount * amount * weight;
    totalWeight += weight;
  }

  final mean = totalWeight > 0 ? sum / totalWeight : 0.0;
  final variance = totalWeight > 0 
      ? (sumSquares / totalWeight) - (mean * mean)
      : 0.0;

  return (mean, sqrt(variance));
}

double _sumTodayExpenses(User user, DateTime today) {
  final expenses = user.transactions;
  return expenses
      .where((e) => e.date.year == today.year &&
                    e.date.month == today.month &&
                    e.date.day == today.day)
      .fold(0.0, (sum, e) => sum + e.amount);
}

double _calculateDataQuality(User user, DateTime today) {
  final expenses = user.transactions;
  final uniqueDays = expenses
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .length;
  
  return (uniqueDays / 7).clamp(0, 1);
}

double _defaultPrior(User user) {
  final expenses = user.transactions;
  if (expenses.isEmpty) return 0.0;
  final firstDate = expenses.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
  final daysActive = DateTime.now().difference(firstDate).inDays + 1;
  return expenses.fold(0.0, (sum, e) => sum + e.amount) / daysActive;
}

double _calculateTrendMomentum(User user, DateTime today) {
  final expenses = user.transactions;
  final dailyTotals = <double>[];
  for (var i = 0; i < 7; i++) {
    final date = today.subtract(Duration(days: i));
    dailyTotals.add(
      expenses
          .where((e) => e.date.year == date.year &&
                        e.date.month == date.month &&
                        e.date.day == date.day)
          .fold(0.0, (sum, e) => sum + e.amount)
    );
  }

  double sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumXX = 0.0;
  for (var i = 0; i < dailyTotals.length; i++) {
    sumX += i.toDouble();
    sumY += dailyTotals[i];
    sumXY += i * dailyTotals[i];
    sumXX += i * i;
  }

  final slope = (7 * sumXY - sumX * sumY) / (7 * sumXX - sumX * sumX);
  return 1 / (1 + exp(-slope * 3)); // Sigmoid normalization
}