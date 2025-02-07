import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swappp/providers/preferences_provider.dart';

class PreferencesService {
  static const String _keyLanguage = 'id';
  static const String _keyCurrency = 'IDR';
  static const String _keyChart = 'chart'; 
  static const String _notification = 'true';
  // TODO: UPDATE THE TOKEN SERVICE
  static const String _keyToken = 'x-auth-token';

  Future<void> getAllPreferences(BuildContext context) async {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    preferencesProvider.setLanguage(prefs.getString(_keyLanguage) ?? 'id');
    preferencesProvider.setCurrency(prefs.getString(_keyCurrency) ?? 'IDR');
    preferencesProvider.setChart(prefs.getString(_keyChart) ?? 'single');
    preferencesProvider.setNotification(prefs.getString(_notification) ?? 'true');
  }

  Future<void> setLanguage(String language, BuildContext context) async {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
    preferencesProvider.setLanguage(language);
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'id';
  }

  Future<void> setCurrency(String currency, BuildContext context) async {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currency);
    preferencesProvider.setCurrency(currency);
  }

  Future<String> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency) ?? 'IDR';
  }

  Future<void> setChart(String chart, BuildContext context) async {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyChart, chart);
    preferencesProvider.setChart(chart);
  }

  Future<String> getChart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyChart) ?? 'single';
  }

  Future<void> setNotification(String notification, BuildContext context) async {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notification, notification);
    preferencesProvider.setNotification(notification);
  }

  Future<String> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_notification) ?? 'true';
  }

  Future<void> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) ?? '';
  }
}