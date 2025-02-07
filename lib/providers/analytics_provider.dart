import 'package:flutter/cupertino.dart';
import 'package:swappp/features/analytics/widgets/chart_plot.dart';

class AnalyticsProvider extends ChangeNotifier {
  List<ChartPoint> _incomeData = [];
  List<ChartPoint> _expenseData = [];

  List<ChartPoint> get incomeData => _incomeData;
  List<ChartPoint> get expenseData => _expenseData;

  void setIncomeData(List<dynamic> data) {
    _incomeData = data.map((item) {
      return ChartPoint(
        DateTime.parse(item['_id']['day']),
        item['totalIncome'].toDouble(),
      );
    }).toList();
    notifyListeners();
  }

  void setExpenseData(List<dynamic> data) {
    _expenseData = data.map((item) {
      return ChartPoint(
        DateTime.parse(item['_id']['day']),
        item['totalExpense'].toDouble(),
      );
    }).toList();
    notifyListeners();
  }
}
