import 'package:dream_bridge_app/services/theam_persistance.dart';
import 'package:dream_bridge_app/utils/theams.dart';
import 'package:flutter/material.dart';

class TheamProvider extends ChangeNotifier {
  TheamProvider() {
    _loadTheme();
  }

  ThemeData _themeData = TheamsModeData().lightmode;

  final TheamPersistance _theamPersistance = TheamPersistance();

  //getter
  ThemeData get getThemeData => _themeData;

  //setter
  set setThemeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  //load the theme from shared preferences

  Future<void> _loadTheme() async {
    bool isDark = await _theamPersistance.loadTheam();
    setThemeData = isDark
        ? TheamsModeData().darkMode
        : TheamsModeData().lightmode;
  }

  //toggle theme
  Future<void> toggleTheme(bool isDark) async {
    setThemeData = isDark
        ? TheamsModeData().darkMode
        : TheamsModeData().lightmode;

    await _theamPersistance.storeTheme(isDark);
    notifyListeners();
  }
}
