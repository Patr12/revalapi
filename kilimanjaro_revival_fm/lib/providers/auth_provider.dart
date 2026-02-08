// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:kilimanjaro_revival_fm/contants/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _currentUser;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _apiService.isLoggedIn();
  
  Future<void> initialize() async {
    await _apiService.init();
    _currentUser = _apiService.getCurrentUser();
    notifyListeners();
  }
  
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _apiService.login(username, password);
      
      if (result['success'] == true) {
        _currentUser = result['user'];
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _apiService.logout();
    _currentUser = null;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}