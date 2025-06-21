import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _themePreferenceKey = 'theme_preference';

  ThemeNotifier() : super(_loadThemeFromPrefs());

  static ThemeMode _loadThemeFromPrefs() {
    // Default to system theme until we load from prefs
    return ThemeMode.system;
  }

  // Initialize from shared preferences
  Future<void> initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePreferenceKey);

    if (savedTheme != null) {
      value = _themeFromString(savedTheme);
    } else {
      // If no saved preference, default to system
      value = ThemeMode.system;
    }
  }

  // Save theme preference
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, _themeToString(mode));
  }

  // Override the setter to save preference when changed
  @override
  set value(ThemeMode newValue) {
    super.value = newValue;
    _saveThemePreference(newValue);
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    value = (value == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
  }

  // Helper methods to convert ThemeMode to/from string
  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _themeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
