import 'package:flutter/material.dart';
import 'package:pfe_gmao/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  ThemeProvider() {
    _loadTheme();
  }
  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  void _saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
      _saveTheme(true);
    } else {
      themeData = lightTheme;
      _saveTheme(false);
    }
    notifyListeners();
  }
}
