import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false;
  }

  static Future<void> saveStreak(int streak) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('streak', streak);
  }

  static Future<int> getStreak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('streak') ?? 0;
  }
}