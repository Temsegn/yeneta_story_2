import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_models.freezed.dart';
part 'subscription_models.g.dart';

@freezed
class CheckoutRequest with _$CheckoutRequest {
  const factory CheckoutRequest({
    required String planId,
  }) = _CheckoutRequest;

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestFromJson(json);
}

@freezed
class CheckoutResponse with _$CheckoutResponse {
  const factory CheckoutResponse({
    required String message,
    required CheckoutData data,
  }) = _CheckoutResponse;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);
}

@freezed
class CheckoutData with _$CheckoutData {
  const factory CheckoutData({
    @JsonKey(name: 'checkout_url') required String checkoutUrl,
    @JsonKey(name: 'tx_ref') required String txRef,
    String? planId,
    double? amount,
    String? currency,
  }) = _CheckoutData;

  factory CheckoutData.fromJson(Map<String, dynamic> json) =>
      _$CheckoutDataFromJson(json);
}

@freezed
class VerifyPaymentResponse with _$VerifyPaymentResponse {
  const factory VerifyPaymentResponse({
    required String message,
    Map<String, dynamic>? data,
  }) = _VerifyPaymentResponse;

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyPaymentResponseFromJson(json);
}

@freezed
class AccessInfo with _$AccessInfo {
  const factory AccessInfo({
    @Default(false) bool hasAccess,
    @Default(false) bool isPremium,
    String? accessType,
    String? plan,
    @Default(0) int daysLeft,
    DateTime? expiresAt,
    String? message,
    @Default(false) bool requiresPayment,
    String? fullName,
  }) = _AccessInfo;

  factory AccessInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessInfoFromJson(json);
}

enum SubscriptionPlan {
  premiumMonthly,
  premiumYearly;

  String get planId {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return 'premium_monthly';
      case SubscriptionPlan.premiumYearly:
        return 'premium_yearly';
    }
  }

  String get displayName {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return 'Monthly';
      case SubscriptionPlan.premiumYearly:
        return 'Yearly';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return 'Full access for 30 days';
      case SubscriptionPlan.premiumYearly:
        return 'Full access for 1 year';
    }
  }

  /// Display-only. Actual amount is always charged by the backend.
  double get price {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return 499.0;
      case SubscriptionPlan.premiumYearly:
        return 4999.0;
    }
  }

  String get priceText {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return '499 ETB';
      case SubscriptionPlan.premiumYearly:
        return '4,999 ETB';
    }
  }

  String get periodLabel {
    switch (this) {
      case SubscriptionPlan.premiumMonthly:
        return '/month';
      case SubscriptionPlan.premiumYearly:
        return '/year';
    }
  }
}
