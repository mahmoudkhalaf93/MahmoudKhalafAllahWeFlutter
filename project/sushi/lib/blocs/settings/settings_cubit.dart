import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  SettingsState({required this.themeMode, required this.locale});
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(themeMode: ThemeMode.light, locale: const Locale('en'))) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final langCode = prefs.getString('lang') ?? 'en';
    
    emit(SettingsState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(langCode),
    ));
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool('isDark', newMode == ThemeMode.dark);
    emit(SettingsState(themeMode: newMode, locale: state.locale));
  }

  Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);
    emit(SettingsState(themeMode: state.themeMode, locale: Locale(langCode)));
  }
}
