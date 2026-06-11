import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import '../core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._prefsService);

  final PrefsService _prefsService;
  
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  
  ThemeData get currentTheme => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  Future<void> loadTheme() async {
    _isDarkMode = await _prefsService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefsService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
