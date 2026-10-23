import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesKeys { amount, years, rate }

class SharedPreferencesHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setDouble(SharedPreferencesKeys key, double value) {
    return _sharedPreferences!.setDouble(key.name, value);
  }

  static double? getDouble(SharedPreferencesKeys key) {
    return _sharedPreferences!.getDouble(key.name);
  }

  static Future<bool> setInt(SharedPreferencesKeys key, int value) {
    return _sharedPreferences!.setInt(key.name, value);
  }

  static int? getInt(SharedPreferencesKeys key) {
    return _sharedPreferences!.getInt(key.name);
  }
}