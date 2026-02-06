// lib/utils/api_response_handler.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponseHandler {
  static Map<String, dynamic> handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': data,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? data['errors'] ?? 'Request failed',
          'statusCode': response.statusCode,
          'data': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to parse response: $e',
        'statusCode': response.statusCode,
      };
    }
  }
  
  static Map<String, dynamic> handleError(dynamic error) {
    if (error is http.ClientException) {
      return {
        'success': false,
        'error': 'Network error: ${error.message}',
      };
    } else if (error is TimeoutException) {
      return {
        'success': false,
        'error': 'Request timeout',
      };
    } else {
      return {
        'success': false,
        'error': 'Unknown error: $error',
      };
    }
  }
}