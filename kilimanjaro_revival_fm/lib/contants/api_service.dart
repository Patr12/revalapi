// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kilimanjaro_revival_fm/contants/api_constants.dart';
import '../core/storage_service.dart';

class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
  
  // Token for authenticated requests
  String? _token;
  
  // Initialize service
  Future<void> init() async {
    await StorageService.init();
    _token = StorageService.getToken();
  }
  
  // ========== HEADER METHODS ==========
  
  Map<String, String> _getPublicHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
  
  Map<String, String> _getAuthHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token',
    };
  }
  
  // ========== AUTHENTICATION METHODS ==========
  
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.login}'),
        headers: _getPublicHeaders(),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Save token and user data
          _token = data['token'];
          await StorageService.saveToken(_token!);
          await StorageService.saveUserData(data['user']);
          
          return {
            'success': true,
            'token': data['token'],
            'user': data['user'],
            'message': 'Login successful',
          };
        }
      }
      
      return {
        'success': false,
        'error': 'Invalid credentials or server error',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  Future<Map<String, dynamic>> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.logout}'),
          headers: _getAuthHeaders(),
        ).timeout(ApiConstants.shortTimeout);
      }
      
      // Clear local storage
      _token = null;
      await StorageService.clearAll();
      
      return {
        'success': true,
        'message': 'Logged out successfully',
      };
    } catch (e) {
      // Even if network fails, clear local storage
      _token = null;
      await StorageService.clearAll();
      
      return {
        'success': true,
        'message': 'Logged out locally',
      };
    }
  }
  
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.register}'),
        headers: _getPublicHeaders(),
        body: jsonEncode(userData),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Auto-login after registration
        _token = data['token'];
        await StorageService.saveToken(_token!);
        await StorageService.saveUserData(data['user']);
        
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': 'Registration successful',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['errors'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.userProfile}'),
        headers: _getAuthHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data['user'],
          'profile': data['profile'],
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
  
  // ========== PUBLIC API METHODS (No auth required) ==========
  
  Future<Map<String, dynamic>> fetchActiveAds() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.adsBaseUrl}${ApiConstants.activeAds}'),
        headers: _getPublicHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'API Error: ${response.statusCode}',
          'data': {'ads': []},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network Error: $e',
        'data': {'ads': []},
      };
    }
  }
  
  Future<Map<String, dynamic>> fetchProgramAds(String programName) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.adsBaseUrl}${ApiConstants.programAds}$programName/'),
        headers: _getPublicHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'API Error: ${response.statusCode}',
          'data': {'ads': []},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network Error: $e',
        'data': {'ads': []},
      };
    }
  }
  
  Future<Map<String, dynamic>> trackClick(String adId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.adsBaseUrl}${ApiConstants.trackClick}$adId/'),
        headers: _getPublicHeaders(),
      ).timeout(ApiConstants.shortTimeout);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Click tracked successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to track click',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network Error: $e',
      };
    }
  }
  
  Future<Map<String, dynamic>> getAdStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.adsBaseUrl}${ApiConstants.adStatistics}'),
        headers: _getPublicHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to fetch statistics',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }
  
  // ========== DASHBOARD API METHODS (Auth required) ==========
  
  Future<Map<String, dynamic>> getAllAds() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.dashboardAds}'),
        headers: _getAuthHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
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
  
  Future<Map<String, dynamic>> createAd(Map<String, dynamic> adData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.dashboardAds}'),
        headers: _getAuthHeaders(),
        body: jsonEncode(adData),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'ad': data['ad'],
          'message': 'Advertisement created successfully',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Unauthorized - Please login again',
          'needsLogin': true,
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
  
  Future<Map<String, dynamic>> updateAd(int id, Map<String, dynamic> adData) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.dashboardAds}$id/'),
        headers: _getAuthHeaders(),
        body: jsonEncode(adData),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'ad': data['ad'],
          'message': 'Advertisement updated successfully',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Unauthorized - Please login again',
          'needsLogin': true,
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
  
  Future<Map<String, dynamic>> deleteAd(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.dashboardAds}$id/'),
        headers: _getAuthHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Advertisement deleted successfully',
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
  
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.dashboardStats}'),
        headers: _getAuthHeaders(),
      ).timeout(ApiConstants.defaultTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'statistics': data['statistics'],
          'recent_ads': data['recent_ads'],
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
  
  // ========== HELPER METHODS ==========
  
  bool isLoggedIn() {
    return _token != null && _token!.isNotEmpty;
  }
  
  String? getToken() {
    return _token;
  }
  
  Map<String, dynamic>? getCurrentUser() {
    return StorageService.getUserData();
  }
  
  Future<void> refreshToken() async {
    _token = StorageService.getToken();
  }
  
  // Check token validity by making a simple API call
  Future<bool> checkTokenValidity() async {
    if (!isLoggedIn()) return false;
    
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.apiBaseUrl}${ApiConstants.userProfile}'),
        headers: _getAuthHeaders(),
      ).timeout(ApiConstants.shortTimeout);
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}