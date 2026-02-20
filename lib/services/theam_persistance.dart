import 'package:shared_preferences/shared_preferences.dart';

class TheamPersistance {
  //store the user's saved theme in shared preferences
  Future<void> storeTheme(bool isDark) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool("isDark", isDark);
    print("Theme stored");
  }

  //load the user's saved theme from shared preferences

  Future<bool> loadTheam() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Theme Loaded");
    return preferences.getBool("isDark") ?? false;
  }
}
