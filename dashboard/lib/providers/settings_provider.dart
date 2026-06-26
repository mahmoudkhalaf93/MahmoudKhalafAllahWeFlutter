import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  bool _isArabic = true;
  bool get isArabic => _isArabic;
  TextDirection get textDirection =>
      _isArabic ? TextDirection.rtl : TextDirection.ltr;
  String get languageCode => _isArabic ? 'ar' : 'en';

  void toggleLanguage() {
    _isArabic = !_isArabic;
    notifyListeners();
  }

  bool _isDark = true;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
