// lib/core/storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  // Initialize storage
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Token management
  static Future<void> saveToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }
  
  static String? getToken() {
    return _prefs?.getString('auth_token');
  }
  
  static Future<void> removeToken() async {
    await _prefs?.remove('auth_token');
  }
  
  // User data management
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    await _prefs?.setString('user_data', jsonEncode(user));
  }
  
  static Map<String, dynamic>? getUserData() {
    final data = _prefs?.getString('user_data');
    return data != null ? jsonDecode(data) : null;
  }
  
  static Future<void> removeUserData() async {
    await _prefs?.remove('user_data');
  }
  
  // Clear all data (logout)
  static Future<void> clearAll() async {
    await removeToken();
    await removeUserData();
  }
}