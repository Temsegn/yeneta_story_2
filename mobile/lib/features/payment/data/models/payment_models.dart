import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

@freezed
class CreatePaymentRequest with _$CreatePaymentRequest {
  const factory CreatePaymentRequest({
    required double amount,
    required String subscription,
    required String paymentMethod,
  }) = _CreatePaymentRequest;

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestFromJson(json);
}

@freezed
class PaymentResponse with _$PaymentResponse {
  const factory PaymentResponse({
    required String message,
    required PaymentData payment,
    Map<String, dynamic>? subscription,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
}

@freezed
class PaymentData with _$PaymentData {
  const factory PaymentData({
    required String id,
    required String userId,
    required double amount,
    required String paymentMethod,
    required String status,
    required String subscription,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentData;

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);
}

@freezed
class PaymentVerification with _$PaymentVerification {
  const factory PaymentVerification({
    required String message,
    required bool verified,
  }) = _PaymentVerification;

  factory PaymentVerification.fromJson(Map<String, dynamic> json) =>
      _$PaymentVerificationFromJson(json);
}
