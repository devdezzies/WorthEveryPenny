import 'package:flutter/material.dart';
import 'package:swappp/common/services/preferences_service.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();

  final String _language = 'id';
  final String _currency = 'IDR';
  String _chartType = 'single';
  final String _notification = 'on';

  String get language => _language;
  String get currency => _currency;
  String get chartType => _chartType;
  String get notification => _notification;

  void setLanguage(String language) {
    language = language;
    notifyListeners();
  }

  void setCurrency(String currency) {
    currency = currency;
    notifyListeners();
  }

  void setChart(String chart) {
    _chartType = chart;
    debugPrint('Chart: $chart');
    notifyListeners();
  }

  void setNotification(String notification) {
    notification = notification;
    notifyListeners();
  }

  void setToken(String token) {
    _preferencesService.setToken(token);
    notifyListeners();
  }
  
  void clearPreferences() {
    _preferencesService.clearPreferences();
    notifyListeners();
  }
}