// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutRequestImpl _$$CheckoutRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckoutRequestImpl(
      planId: json['planId'] as String,
    );

Map<String, dynamic> _$$CheckoutRequestImplToJson(
        _$CheckoutRequestImpl instance) =>
    <String, dynamic>{
      'planId': instance.planId,
    };

_$CheckoutResponseImpl _$$CheckoutResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckoutResponseImpl(
      message: json['message'] as String,
      data: CheckoutData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CheckoutResponseImplToJson(
        _$CheckoutResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

_$CheckoutDataImpl _$$CheckoutDataImplFromJson(Map<String, dynamic> json) =>
    _$CheckoutDataImpl(
      checkoutUrl: json['checkout_url'] as String,
      txRef: json['tx_ref'] as String,
      planId: json['planId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$CheckoutDataImplToJson(_$CheckoutDataImpl instance) =>
    <String, dynamic>{
      'checkout_url': instance.checkoutUrl,
      'tx_ref': instance.txRef,
      'planId': instance.planId,
      'amount': instance.amount,
      'currency': instance.currency,
    };

_$VerifyPaymentResponseImpl _$$VerifyPaymentResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyPaymentResponseImpl(
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VerifyPaymentResponseImplToJson(
        _$VerifyPaymentResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

_$AccessInfoImpl _$$AccessInfoImplFromJson(Map<String, dynamic> json) =>
    _$AccessInfoImpl(
      hasAccess: json['hasAccess'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      accessType: json['accessType'] as String?,
      plan: json['plan'] as String?,
      daysLeft: (json['daysLeft'] as num?)?.toInt() ?? 0,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      message: json['message'] as String?,
      requiresPayment: json['requiresPayment'] as bool? ?? false,
      fullName: json['fullName'] as String?,
    );

Map<String, dynamic> _$$AccessInfoImplToJson(_$AccessInfoImpl instance) =>
    <String, dynamic>{
      'hasAccess': instance.hasAccess,
      'isPremium': instance.isPremium,
      'accessType': instance.accessType,
      'plan': instance.plan,
      'daysLeft': instance.daysLeft,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'message': instance.message,
      'requiresPayment': instance.requiresPayment,
      'fullName': instance.fullName,
    };
