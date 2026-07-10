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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRemoteDataSourceImpl(this._dio, this._tokenStorage);

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.auth}/register',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save tokens and user data for persistent session
      if (response.data['user']?['accessToken'] != null) {
        await _tokenStorage.saveAccessToken(response.data['user']['accessToken']);
      }
      if (response.data['user']?['refreshToken'] != null) {
        await _tokenStorage.saveRefreshToken(response.data['user']['refreshToken']);
      }
      // Save user data
      await _tokenStorage.saveUserData(response.data['user']);
      
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
      
      // Save tokens and user data for persistent session
      if (response.data['user']?['accessToken'] != null) {
        await _tokenStorage.saveAccessToken(response.data['user']['accessToken']);
      }
      if (response.data['user']?['refreshToken'] != null) {
        await _tokenStorage.saveRefreshToken(response.data['user']['refreshToken']);
      }
      // Save user data
      await _tokenStorage.saveUserData(response.data['user']);
      
      return authResponse;
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
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
