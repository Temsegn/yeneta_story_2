/// API configuration constants
class ApiConfig {
  // Production API URL
  static const String baseUrl = 'https://yeneta-story-2.onrender.com/api/v1';
  
  // For local development, uncomment this line:
  // static const String baseUrl = 'http://10.0.2.2:5000/api/v1'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000/api/v1'; // iOS simulator
  
  // Endpoints
  static const String auth = '/auth';
  static const String videos = '/videos';
  static const String books = '/books';
  static const String stories = '/stories';
  static const String subscriptions = '/subscriptions';
  static const String payments = '/payments';
  
  // Timeouts (increased for Render cold starts)
  static const Duration connectTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
