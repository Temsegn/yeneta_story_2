// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePaymentRequestImpl _$$CreatePaymentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePaymentRequestImpl(
      amount: (json['amount'] as num).toDouble(),
      subscription: json['subscription'] as String,
      paymentMethod: json['paymentMethod'] as String,
    );

Map<String, dynamic> _$$CreatePaymentRequestImplToJson(
        _$CreatePaymentRequestImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'subscription': instance.subscription,
      'paymentMethod': instance.paymentMethod,
    };

_$PaymentResponseImpl _$$PaymentResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentResponseImpl(
      message: json['message'] as String,
      payment: PaymentData.fromJson(json['payment'] as Map<String, dynamic>),
      subscription: json['subscription'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentResponseImplToJson(
        _$PaymentResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'payment': instance.payment,
      'subscription': instance.subscription,
    };

_$PaymentDataImpl _$$PaymentDataImplFromJson(Map<String, dynamic> json) =>
    _$PaymentDataImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      subscription: json['subscription'] as String,
      transactionId: json['transactionId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PaymentDataImplToJson(_$PaymentDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'subscription': instance.subscription,
      'transactionId': instance.transactionId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$PaymentVerificationImpl _$$PaymentVerificationImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentVerificationImpl(
      message: json['message'] as String,
      verified: json['verified'] as bool,
    );

Map<String, dynamic> _$$PaymentVerificationImplToJson(
        _$PaymentVerificationImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'verified': instance.verified,
    };
