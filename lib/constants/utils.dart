import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/models/transaction.dart';
import 'package:swappp/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}";
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

final List<Map<String, dynamic>> categories = [
  {"title": "Food and Beverages", "emoji": "🍔"},
  {"title": "Transportation", "emoji": "🚗"},
  {"title": "Shopping", "emoji": "🛍️"},
  {"title": "Entertainment", "emoji": "🎬"},
  {"title": "Groceries", "emoji": "🛒"},
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
  twelveHour =
      twelveHour == 0 ? 12 : twelveHour; // Handle 0 (midnight) as 12 AM
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

class GradientIntensityMeter extends StatelessWidget {
  final double value; // Value between 0 and 100
  final double width;
  final double height;
  final bool isIncome;

  const GradientIntensityMeter({
    super.key,
    required this.value,
    this.width = 60,
    this.height = 8,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: LinearGradient(
          colors: !isIncome
              ? const [
                  Color(0xFF00FFBB),
                  Color(0xFFFFFF00),
                  Color(0xFFFF3434),
                ]
              : const [
                  Color(0xFFFF3434),
                  Color(0xFFFFFF00),
                  Color(0xFF00FFBB),
                ],
          stops: const [0.0, 0.5, 1.0],
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
      .where((t) =>
          t.type == 'expense' &&
          t.date.isBefore(today.add(const Duration(days: 1))))
      .toList();

  // 2. Edge case handling
  if (expenses.isEmpty) return 0.0; // Perfect score for no expenses
  if (expenses.every((e) => e.date.isAtSameMomentAs(today))) return 100.0; // First day

  // 3. Time-weighted statistics
  final (double mean, double stdDev) = _calculateWeightedStats(user, today);
  final todayTotal = _sumTodayExpenses(user, today);

  // 4. Bayesian inference for sparse data
  final dataQuality = _calculateDataQuality(user, today);
  final adjustedMean =
      dataQuality * mean + (1 - dataQuality) * _defaultPrior(user);

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
  final variance =
      totalWeight > 0 ? (sumSquares / totalWeight) - (mean * mean) : 0.0;

  return (mean, sqrt(variance));
}

double _sumTodayExpenses(User user, DateTime today) {
  final expenses = user.transactions;
  return expenses
      .where((e) =>
          e.date.year == today.year &&
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
  final firstDate =
      expenses.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
  final daysActive = DateTime.now().difference(firstDate).inDays + 1;
  return expenses.fold(0.0, (sum, e) => sum + e.amount) / daysActive;
}

double _calculateTrendMomentum(User user, DateTime today) {
  final expenses = user.transactions;
  final dailyTotals = <double>[];
  for (var i = 0; i < 7; i++) {
    final date = today.subtract(Duration(days: i));
    dailyTotals.add(expenses
        .where((e) =>
            e.date.year == date.year &&
            e.date.month == date.month &&
            e.date.day == date.day)
        .fold(0.0, (sum, e) => sum + e.amount));
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

double calculateIncomeGrowth(List<Transaction> transactions) {
  final now = DateTime.now();
  final cutoff = now.subtract(const Duration(days: 90)); // 3-month analysis

  // 1. Data preparation
  final incomes = transactions
      .where((t) => t.type == 'income' && t.date.isAfter(cutoff))
      .toList();

  final expenses = transactions
      .where((t) => t.type == 'expense' && t.date.isAfter(cutoff))
      .toList();

  // 2. Edge case handling
  if (incomes.isEmpty) return 0.0;
  if (incomes.length == 1) return 50.0; // Neutral score for single income

  // 3. Core calculations
  final dailyIncome = _groupByDay(incomes, now);
  final dailyExpenses = _groupByDay(expenses, now);

  final stability = _calculateIncomeStability(dailyIncome);
  final growth = _calculateGrowthRate(dailyIncome);
  final coverage = _calculateCoverageRatio(dailyIncome, dailyExpenses);
  final momentum = _calculateIncomeMomentum(dailyIncome);

  // 4. Composite score
  final score =
      (stability * 0.4) + (growth * 0.3) + (coverage * 0.2) + (momentum * 0.1);

  return score.clamp(0, 100).toDouble();
}

// Helper functions
Map<DateTime, double> _groupByDay(
    List<Transaction> transactions, DateTime now) {
  final dailyTotals = <DateTime, double>{};
  for (final t in transactions) {
    final day = DateTime(t.date.year, t.date.month, t.date.day);
    dailyTotals[day] = (dailyTotals[day] ?? 0.0) + t.amount;
  }
  return dailyTotals;
}

double _calculateIncomeStability(Map<DateTime, double> dailyIncome) {
  final amounts = dailyIncome.values.toList();
  final mean = amounts.average;
  final stdDev = _standardDeviation(amounts, mean);
  return (1 - (stdDev / (mean + 1e-10))).clamp(0, 1) * 100;
}

double _calculateGrowthRate(Map<DateTime, double> dailyIncome) {
  final sortedDays = dailyIncome.keys.toList()..sort();
  final firstMonth = _monthValue(sortedDays.first);
  final lastMonth = _monthValue(sortedDays.last);

  final monthlyGrowth = (lastMonth.total / firstMonth.total - 1) * 100;
  return monthlyGrowth.clamp(-50, 100); // Cap at 100% growth
}

double _calculateCoverageRatio(
    Map<DateTime, double> income, Map<DateTime, double> expenses) {
  double totalIncome = income.values.fold(0.0, (s, v) => s + v);
  double totalExpenses = expenses.values.fold(0.0, (s, v) => s + v);
  final ratio = totalIncome / (totalExpenses + 1e-10);
  return (min(ratio, 2.0) * 50).clamp(0, 100); // 2x coverage = 100
}

double _calculateIncomeMomentum(Map<DateTime, double> dailyIncome) {
  final sorted = dailyIncome.keys.toList()..sort();
  final last14Days = sorted.sublist(max(0, sorted.length - 14));
  final amounts = last14Days.map((d) => dailyIncome[d] ?? 0.0).toList();

  double sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumXX = 0.0;
  for (int i = 0; i < amounts.length; i++) {
    sumX += i.toDouble();
    sumY += amounts[i];
    sumXY += i * amounts[i];
    sumXX += i * i;
  }

  final slope = (amounts.length * sumXY - sumX * sumY) /
      (amounts.length * sumXX - sumX * sumX);
  return (slope * 100).clamp(-100, 100);
}

// Utility extensions
extension on List<double> {
  double get average => isEmpty ? 0 : reduce((a, b) => a + b) / length;
}

double _standardDeviation(List<double> values, double mean) {
  if (values.length < 2) return 0.0;
  final variance =
      values.fold(0.0, (sum, v) => sum + pow(v - mean, 2)) / values.length;
  return sqrt(variance);
}

class _MonthSummary {
  final int year;
  final int month;
  double total = 0.0;

  _MonthSummary(this.year, this.month);
}

_MonthSummary _monthValue(DateTime date) {
  return _MonthSummary(date.year, date.month);
}

// HELPER MAPPING FUNCTIONS

class FinancialInsight {
  final String insight;
  final String recommendation;
  final String emoji;

  const FinancialInsight({
    required this.insight,
    required this.recommendation,
    required this.emoji,
  });
}

FinancialInsight getFinancialInsight(double score, String type) {
  assert(type == 'income' || type == 'expense',
      'Type must be "income" or "expense"');

  if (type == 'income') {
    if (score >= 80) {
      return const FinancialInsight(
        insight: 'Strong income growth & high stability',
        recommendation: 'Invest surplus, plan long-term',
        emoji: '🌟',
      );
    } else if (score >= 60) {
      return const FinancialInsight(
        insight: 'Reliable income with moderate growth',
        recommendation: 'Maintain & optimize income streams',
        emoji: '💰',
      );
    } else if (score >= 40) {
      return const FinancialInsight(
        insight: 'Stable but stagnant income',
        recommendation: 'Seek growth opportunities',
        emoji: '🌼',
      );
    } else if (score >= 20) {
      return const FinancialInsight(
        insight: 'Volatile income with low coverage',
        recommendation: 'Diversify income sources',
        emoji: '⚡️',
      );
    } else {
      return const FinancialInsight(
        insight: 'Highly unstable income',
        recommendation: 'Create an emergency fund',
        emoji: '🚨',
      );
    }
  } else {
    // type == 'expense'
    if (score >= 80) {
      return const FinancialInsight(
        insight: 'Significantly over your usual spending',
        recommendation: 'Pause and check finances',
        emoji: '😱',
      );
    } else if (score >= 60) {
      return const FinancialInsight(
        insight: 'Spending more than usual',
        recommendation: 'Review budget before buying more',
        emoji: '😟',
      );
    } else if (score >= 40) {
      return const FinancialInsight(
        insight: 'Normal spending range',
        recommendation: 'Maintain current habits',
        emoji: '😉',
      );
    } else if (score >= 20) {
      return const FinancialInsight(
        insight: 'Spending less than usual',
        recommendation: 'Good time to save',
        emoji: '😄',
      );
    } else {
      return const FinancialInsight(
        insight: 'Exceptional saving day',
        recommendation: 'Proceed with purchases (within reason)',
        emoji: '😍',
      );
    }
  }
}

// SHOW MODAL BOTTOM SHEET

void showFinancialMetricsGuide(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
            color: GlobalVariables.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildMetricSection(
                icon: '💸',
                title: "Spending Pulse",
                description: "Understand your daily spending habits instantly",
                color: GlobalVariables.secondaryColor,
                examples: [
                  "☕ Shows if your coffee runs are becoming too regular",
                  "🛒 Helps catch 'small' purchases adding up quickly",
                  "🎉 Warns when weekend spending is higher than usual",
                ],
              ),
              const SizedBox(height: 24),
              _buildTipSection(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: GlobalVariables.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Got it! Let me try',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildMetricSection({
  required String icon,
  required String title,
  required String description,
  required Color color,
  required List<String> examples,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ...examples.map((example) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    example,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
    ],
  );
}

Widget _buildTipSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: GlobalVariables.greyBackgroundColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pro Tips ✨',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTipItem("🕒 Check before big purchases"),
        _buildTipItem("📅 Review weekly every Sunday"),
        _buildTipItem("🎯 Focus on improving one metric at a time"),
        _buildTipItem("💡 Tap numbers to see detailed breakdowns"),
      ],
    ),
  );
}

Widget _buildTipItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

// DATE UTILS

// function that returns String from a date format "2025-02" return February 2025
String getMonthYear(String date) {
  final List<String> dateParts = date.split("-");
  final int month = int.parse(dateParts[1]);
  final int year = int.parse(dateParts[0]);
  return "${monthName(month)} $year";
}

// function that returns String from a date format "2025-02-05" return 5 February 2025
String getFullDate(String date) {
  final List<String> dateParts = date.split("-");
  final int day = int.parse(dateParts[2]);
  final int month = int.parse(dateParts[1]);
  final int year = int.parse(dateParts[0]);
  return "$day ${monthName(month)} $year";
}

// show modal bottom sheet with WebView
void showWebViewModalBottomSheet({
  required BuildContext context,
  required String url,
  String? title,
  String? subtitle,
  bool isScrollControlled = true,
}) {
  // Initialize WebView controller for better performance
  final WebViewController webViewController = WebViewController();

  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    title ?? 'WebView',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
            // WebView
            Expanded(
              child: WebViewWidget(
                controller: webViewController
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(NavigationDelegate(
                    onProgress: (_) {
                      const CircularProgressIndicator();
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onHttpError: (HttpResponseError error) {},
                    onWebResourceError: (WebResourceError error) {},
                  ))
                  ..loadRequest(Uri.parse(url)),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

// CONVERTER
DateTime convertUtcToDateTime(DateTime utc) {
  final now = utc.toIso8601String();
  return DateTime.parse(now).toLocal();
}
