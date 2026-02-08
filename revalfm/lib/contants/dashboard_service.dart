// lib/services/dashboard_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class DashboardService {
  static const String baseUrl = 'http://192.168.1.3:8000/ads';
  
  // Get all ads (for dashboard)
  static Future<Map<String, dynamic>> getAllAds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/ads/'),
        headers: AuthService.getAuthHeaders(),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'ads': data['ads'],
          'count': data['count'],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Unauthorized - Please login again',
          'needsLogin': true,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch ads',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Create new ad
  static Future<Map<String, dynamic>> createAd(Map<String, dynamic> adData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dashboard/ads/'),
        headers: AuthService.getAuthHeaders(),
        body: jsonEncode(adData),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'ad': data['ad'],
          'message': 'Advertisement created successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['errors'] ?? 'Failed to create ad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Update ad
  static Future<Map<String, dynamic>> updateAd(int id, Map<String, dynamic> adData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/dashboard/ads/$id/'),
        headers: AuthService.getAuthHeaders(),
        body: jsonEncode(adData),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'ad': data['ad'],
          'message': 'Advertisement updated successfully',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['errors'] ?? 'Failed to update ad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Delete ad
  static Future<Map<String, dynamic>> deleteAd(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/dashboard/ads/$id/'),
        headers: AuthService.getAuthHeaders(),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Advertisement deleted successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to delete ad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Get dashboard statistics
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard/stats/'),
        headers: AuthService.getAuthHeaders(),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'statistics': data['statistics'],
          'recent_ads': data['recent_ads'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch dashboard statistics',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile/'),
        headers: AuthService.getAuthHeaders(),
      ).timeout(Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data['user'],
          'profile': data['profile'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
}