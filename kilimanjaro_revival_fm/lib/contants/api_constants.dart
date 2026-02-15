// lib/core/api_constants.dart
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://192.168.1.199:8000';
  static const String apiBaseUrl = '$baseUrl/ads';
  static const String adsBaseUrl = '$baseUrl/ads';

  // Public API Endpoints (for mobile app - no auth required)
  static const String activeAds = '/active/';
  static const String programAds = '/program/';
  static const String trackClick = '/track-click/';
  static const String adStatistics = '/statistics/';

  // Authentication Endpoints
  static const String login = '/auth/login/';
  static const String logout = '/auth/logout/';
  static const String register = '/auth/register/';
  static const String userProfile = '/auth/profile/';

  // Dashboard Management Endpoints (require authentication)
  static const String dashboardAds = '/dashboard/ads/';
  static const String dashboardStats = '/dashboard/stats/';

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration shortTimeout = Duration(seconds: 5);
}
