import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _dailyReminderKey = 'daily_reminder';
  late SharedPreferences _prefs;
  bool _isDailyReminderActive = false;

  bool get isDailyReminderActive => _isDailyReminderActive;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _isDailyReminderActive = _prefs.getBool(_dailyReminderKey) ?? false;
    notifyListeners();
  }

  Future<void> setDailyReminder(bool value) async {
    _isDailyReminderActive = value;
    await _prefs.setBool(_dailyReminderKey, value);
    notifyListeners();
  }
}
