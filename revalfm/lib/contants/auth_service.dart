// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.3:8000/ads';
  static String? _token;
  
  // Initialize token from shared preferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }
  
  // Login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          _token = data['token'];
          
          // Save token to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          await prefs.setString('user_data', jsonEncode(data['user']));
          
          return {
            'success': true,
            'user': data['user'],
            'token': data['token'],
          };
        }
      }
      
      return {
        'success': false,
        'error': 'Invalid credentials',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Logout
  static Future<void> logout() async {
    if (_token != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token',
        },
      );
    }
    
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
    }
    return _token != null;
  }
  
  // Get authorization headers
  static Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token',
    };
  }
}