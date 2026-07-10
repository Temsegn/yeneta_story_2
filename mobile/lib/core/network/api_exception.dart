import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout. Please check your internet connection.', null);
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String message = 'Server error';
        
        // Extract message from response data
        try {
          final data = error.response?.data;
          if (data is Map) {
            // Try to get message field
            final msgField = data['message'];
            
            if (msgField is String) {
              message = msgField;
            } else if (msgField is Map) {
              // If message is an object, try to extract error info
              message = msgField['error']?.toString() ?? 
                       msgField['message']?.toString() ?? 
                       msgField.toString();
            } else if (msgField != null) {
              message = msgField.toString();
            }
            
            // Fallback to error field
            if (message == 'Server error' || message == '[object Object]') {
              message = data['error']?.toString() ?? 'Server error';
            }
          } else if (data is String) {
            message = data;
          }
          
          // Clean up [object Object] messages
          if (message.contains('[object Object]')) {
            message = 'Server error. Please try again.';
          }
        } catch (e) {
          message = 'Server error';
        }
        
        // Handle specific status codes
        if (statusCode == 401) {
          return ApiException('Unauthorized. Please login again.', statusCode);
        } else if (statusCode == 400) {
          return ApiException(message, statusCode);
        } else if (statusCode == 404) {
          return ApiException('Service not found. Please check your connection.', statusCode);
        } else if (statusCode == 500) {
          return ApiException('Server error. Please try again later.', statusCode);
        }
        
        return ApiException(message, statusCode);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled', null);
      case DioExceptionType.connectionError:
        return ApiException('Cannot connect to server. Please check your internet connection.', null);
      case DioExceptionType.unknown:
        return ApiException('Network error. Please check your connection and try again.', null);
      default:
        return ApiException('Network error. Please try again.', null);
    }
  }

  @override
  String toString() => message;
}
