// core/helper/shared_preference.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String _keyUID = 'uid';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Save UID
  static Future<void> saveUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUID, uid);
  }

  // Save Logged-In Status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  // Save UID
  static Future<String?> getUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUID);
  }

  // Save Logged-In Status
  static Future<bool?> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn);
  }
}
