// lib/providers/ads_provider.dart
import 'package:flutter/material.dart';
import 'package:revalfm/contants/api_service.dart';
import 'package:revalfm/model/advertisement.dart';


class AdsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String? _error;
  List<Advertisement> _ads = [];
  Map<String, dynamic>? _statistics;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Advertisement> get ads => _ads;
  Map<String, dynamic>? get statistics => _statistics;
  int get totalAds => _ads.length;
  int get activeAdsCount => _ads.where((ad) => ad.status == 'active').length;
  
  // Load all ads
  Future<void> loadAds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _apiService.getAllAds();
      
      if (result['success'] == true) {
        _ads = (result['ads'] as List)
            .map((json) => Advertisement.fromJson(json))
            .toList();
        _error = null;
      } else {
        _error = result['error'];
        _ads = [];
      }
    } catch (e) {
      _error = 'Failed to load ads: $e';
      _ads = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Create new ad
  Future<Map<String, dynamic>> createAd(Advertisement ad) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _apiService.createAd(ad.toJson());
      
      _isLoading = false;
      notifyListeners();
      
      if (result['success'] == true) {
        // Reload ads to include the new one
        await loadAds();
        return {
          'success': true,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'],
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': 'Failed to create ad: $e',
      };
    }
  }
  
  // Update ad
  Future<Map<String, dynamic>> updateAd(int id, Advertisement ad) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _apiService.updateAd(id, ad.toJson());
      
      _isLoading = false;
      notifyListeners();
      
      if (result['success'] == true) {
        // Update local list
        final index = _ads.indexWhere((a) => a.id == id);
        if (index != -1) {
          _ads[index] = ad.copyWith(id: id);
          notifyListeners();
        }
        return {
          'success': true,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'],
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': 'Failed to update ad: $e',
      };
    }
  }
  
  // Delete ad
  Future<Map<String, dynamic>> deleteAd(int id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _apiService.deleteAd(id);
      
      _isLoading = false;
      
      if (result['success'] == true) {
        // Remove from local list
        _ads.removeWhere((ad) => ad.id == id);
        notifyListeners();
        return {
          'success': true,
          'message': result['message'],
        };
      } else {
        return {
          'success': false,
          'error': result['error'],
        };
      }
    } catch (e) {
      _isLoading = false;
      return {
        'success': false,
        'error': 'Failed to delete ad: $e',
      };
    }
  }
  
  // Load statistics
  Future<void> loadStatistics() async {
    try {
      final result = await _apiService.getDashboardStats();
      
      if (result['success'] == true) {
        _statistics = result['statistics'];
      } else {
        _statistics = null;
      }
    } catch (e) {
      _statistics = null;
    }
    
    notifyListeners();
  }
  
  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}