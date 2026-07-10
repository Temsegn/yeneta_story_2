import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/payment_models.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentResponse> createPayment(CreatePaymentRequest request);
  Future<PaymentVerification> verifyPayment(String transactionId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl(this._dio);

  @override
  Future<PaymentResponse> createPayment(CreatePaymentRequest request) async {
    try {
      final response = await _dio.post(
        ApiConfig.payments,
        data: request.toJson(),
      );
      return PaymentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<PaymentVerification> verifyPayment(String transactionId) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.payments}/verify',
        data: {'transactionId': transactionId},
      );
      return PaymentVerification.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
