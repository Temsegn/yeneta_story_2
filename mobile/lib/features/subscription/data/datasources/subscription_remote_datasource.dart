import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/subscription_models.dart';

abstract class SubscriptionRemoteDataSource {
  Future<CheckoutResponse> checkout(String planId);
  Future<VerifyPaymentResponse> verifyPayment(String txRef);
  Future<AccessInfo> getMySubscription();
  Future<AccessInfo> checkAccess();
}

class SubscriptionRemoteDataSourceImpl
    implements SubscriptionRemoteDataSource {
  final Dio _dio;

  SubscriptionRemoteDataSourceImpl(this._dio);

  @override
  Future<CheckoutResponse> checkout(String planId) async {
    try {
      debugPrint('CHECKOUT request planId=$planId');
      final response = await _dio.post(
        '${ApiConfig.subscriptions}/checkout',
        data: {'planId': planId},
      );
      debugPrint('CHECKOUT success: ${response.statusCode}');
      return CheckoutResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint(
        'CHECKOUT DioException: status=${e.response?.statusCode} data=${e.response?.data}',
      );
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<VerifyPaymentResponse> verifyPayment(String txRef) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.payments}/chapa/verify/$txRef',
      );
      return VerifyPaymentResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AccessInfo> getMySubscription() async {
    try {
      final response = await _dio.get('${ApiConfig.subscriptions}/me');
      return AccessInfo.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<AccessInfo> checkAccess() async {
    // Prefer new /subscriptions/me; fall back to legacy check-access.
    try {
      return await getMySubscription();
    } catch (_) {
      try {
        final response = await _dio.get(
          '${ApiConfig.payments}/chapa/check-access',
        );
        return AccessInfo.fromJson(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        throw ApiException.fromDioError(e);
      }
    }
  }
}
