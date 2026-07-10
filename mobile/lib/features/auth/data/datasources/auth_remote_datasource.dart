import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> register(RegisterRequest request);
  Future<AuthResponse> login(LoginRequest request);
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UpdateProfileRequest request);
  Future<ForgotPasswordResponse> requestPasswordReset(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRemoteDataSourceImpl(this._dio, this._tokenStorage);

  Future<void> _persistSession(Map<String, dynamic> data) async {
    final userJson = data['user'];
    if (userJson is! Map<String, dynamic>) {
      throw ApiException('Invalid auth response from server.');
    }

    final accessToken = userJson['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException(
        'Sign-in succeeded but no access token was returned. '
        'Deploy the latest backend, then sign in again.',
      );
    }

    await _tokenStorage.saveAccessToken(accessToken);

    final refreshToken = userJson['refreshToken'] as String?;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _tokenStorage.saveRefreshToken(refreshToken);
    }

    final userForStorage = Map<String, dynamic>.from(userJson);
    userForStorage.remove('accessToken');
    userForStorage.remove('refreshToken');
    await _tokenStorage.saveUserData(userForStorage);
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.auth}/register',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _persistSession(response.data as Map<String, dynamic>);

      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.auth}/login',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _persistSession(response.data as Map<String, dynamic>);

      return authResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<ForgotPasswordResponse> requestPasswordReset(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.auth}/forgot-password',
        data: request.toJson(),
      );
      return ForgotPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dio.post(
        '${ApiConfig.auth}/reset-password',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      final response = await _dio.get('${ApiConfig.auth}/profile');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _dio.put(
        '${ApiConfig.auth}/profile',
        data: request.toJson(),
      );
      final data = response.data;
      if (data is Map && data['user'] is Map) {
        return UserProfile.fromJson(
          Map<String, dynamic>.from(data['user'] as Map),
        );
      }
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
