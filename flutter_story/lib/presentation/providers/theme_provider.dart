import 'package:flutter/material.dart';
import '../../data/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _languageCode = 'en';

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;

  Future<void> loadSettings() async {
    _isDarkMode = await StorageService.getThemeMode();
    _languageCode = await StorageService.getLanguage();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _languageCode = languageCode;
    await StorageService.saveLanguage(languageCode);
    notifyListeners();
  }
}
