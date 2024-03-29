import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStore {
  static Future<bool> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String> getString(String key, [String defaultValue = '']) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<bool> saveMap(String key, Map<String, dynamic> value) async {
    return saveString(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>> getMap(String key, [Map<String, dynamic> defaultValue = const {}]) async {
    return jsonDecode(await getString(key, jsonEncode(defaultValue)));
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
