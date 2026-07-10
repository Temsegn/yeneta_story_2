// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CheckoutRequest _$CheckoutRequestFromJson(Map<String, dynamic> json) {
  return _CheckoutRequest.fromJson(json);
}

/// @nodoc
mixin _$CheckoutRequest {
  String get planId => throw _privateConstructorUsedError;

  /// Serializes this CheckoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutRequestCopyWith<CheckoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutRequestCopyWith<$Res> {
  factory $CheckoutRequestCopyWith(
          CheckoutRequest value, $Res Function(CheckoutRequest) then) =
      _$CheckoutRequestCopyWithImpl<$Res, CheckoutRequest>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class _$CheckoutRequestCopyWithImpl<$Res, $Val extends CheckoutRequest>
    implements $CheckoutRequestCopyWith<$Res> {
  _$CheckoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckoutRequestImplCopyWith<$Res>
    implements $CheckoutRequestCopyWith<$Res> {
  factory _$$CheckoutRequestImplCopyWith(_$CheckoutRequestImpl value,
          $Res Function(_$CheckoutRequestImpl) then) =
      __$$CheckoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$CheckoutRequestImplCopyWithImpl<$Res>
    extends _$CheckoutRequestCopyWithImpl<$Res, _$CheckoutRequestImpl>
    implements _$$CheckoutRequestImplCopyWith<$Res> {
  __$$CheckoutRequestImplCopyWithImpl(
      _$CheckoutRequestImpl _value, $Res Function(_$CheckoutRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_$CheckoutRequestImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutRequestImpl implements _CheckoutRequest {
  const _$CheckoutRequestImpl({required this.planId});

  factory _$CheckoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutRequestImplFromJson(json);

  @override
  final String planId;

  @override
  String toString() {
    return 'CheckoutRequest(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutRequestImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutRequestImplCopyWith<_$CheckoutRequestImpl> get copyWith =>
      __$$CheckoutRequestImplCopyWithImpl<_$CheckoutRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutRequestImplToJson(
      this,
    );
  }
}

abstract class _CheckoutRequest implements CheckoutRequest {
  const factory _CheckoutRequest({required final String planId}) =
      _$CheckoutRequestImpl;

  factory _CheckoutRequest.fromJson(Map<String, dynamic> json) =
      _$CheckoutRequestImpl.fromJson;

  @override
  String get planId;

  /// Create a copy of CheckoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutRequestImplCopyWith<_$CheckoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckoutResponse _$CheckoutResponseFromJson(Map<String, dynamic> json) {
  return _CheckoutResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckoutResponse {
  String get message => throw _privateConstructorUsedError;
  CheckoutData get data => throw _privateConstructorUsedError;

  /// Serializes this CheckoutResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutResponseCopyWith<CheckoutResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutResponseCopyWith<$Res> {
  factory $CheckoutResponseCopyWith(
          CheckoutResponse value, $Res Function(CheckoutResponse) then) =
      _$CheckoutResponseCopyWithImpl<$Res, CheckoutResponse>;
  @useResult
  $Res call({String message, CheckoutData data});

  $CheckoutDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CheckoutResponseCopyWithImpl<$Res, $Val extends CheckoutResponse>
    implements $CheckoutResponseCopyWith<$Res> {
  _$CheckoutResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CheckoutData,
    ) as $Val);
  }

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutDataCopyWith<$Res> get data {
    return $CheckoutDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutResponseImplCopyWith<$Res>
    implements $CheckoutResponseCopyWith<$Res> {
  factory _$$CheckoutResponseImplCopyWith(_$CheckoutResponseImpl value,
          $Res Function(_$CheckoutResponseImpl) then) =
      __$$CheckoutResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, CheckoutData data});

  @override
  $CheckoutDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CheckoutResponseImplCopyWithImpl<$Res>
    extends _$CheckoutResponseCopyWithImpl<$Res, _$CheckoutResponseImpl>
    implements _$$CheckoutResponseImplCopyWith<$Res> {
  __$$CheckoutResponseImplCopyWithImpl(_$CheckoutResponseImpl _value,
      $Res Function(_$CheckoutResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = null,
  }) {
    return _then(_$CheckoutResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CheckoutData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutResponseImpl implements _CheckoutResponse {
  const _$CheckoutResponseImpl({required this.message, required this.data});

  factory _$CheckoutResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutResponseImplFromJson(json);

  @override
  final String message;
  @override
  final CheckoutData data;

  @override
  String toString() {
    return 'CheckoutResponse(message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, data);

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutResponseImplCopyWith<_$CheckoutResponseImpl> get copyWith =>
      __$$CheckoutResponseImplCopyWithImpl<_$CheckoutResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckoutResponse implements CheckoutResponse {
  const factory _CheckoutResponse(
      {required final String message,
      required final CheckoutData data}) = _$CheckoutResponseImpl;

  factory _CheckoutResponse.fromJson(Map<String, dynamic> json) =
      _$CheckoutResponseImpl.fromJson;

  @override
  String get message;
  @override
  CheckoutData get data;

  /// Create a copy of CheckoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutResponseImplCopyWith<_$CheckoutResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckoutData _$CheckoutDataFromJson(Map<String, dynamic> json) {
  return _CheckoutData.fromJson(json);
}

/// @nodoc
mixin _$CheckoutData {
  @JsonKey(name: 'checkout_url')
  String get checkoutUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'tx_ref')
  String get txRef => throw _privateConstructorUsedError;
  String? get planId => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  /// Serializes this CheckoutData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutDataCopyWith<CheckoutData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutDataCopyWith<$Res> {
  factory $CheckoutDataCopyWith(
          CheckoutData value, $Res Function(CheckoutData) then) =
      _$CheckoutDataCopyWithImpl<$Res, CheckoutData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'checkout_url') String checkoutUrl,
      @JsonKey(name: 'tx_ref') String txRef,
      String? planId,
      double? amount,
      String? currency});
}

/// @nodoc
class _$CheckoutDataCopyWithImpl<$Res, $Val extends CheckoutData>
    implements $CheckoutDataCopyWith<$Res> {
  _$CheckoutDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutUrl = null,
    Object? txRef = null,
    Object? planId = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
  }) {
    return _then(_value.copyWith(
      checkoutUrl: null == checkoutUrl
          ? _value.checkoutUrl
          : checkoutUrl // ignore: cast_nullable_to_non_nullable
              as String,
      txRef: null == txRef
          ? _value.txRef
          : txRef // ignore: cast_nullable_to_non_nullable
              as String,
      planId: freezed == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckoutDataImplCopyWith<$Res>
    implements $CheckoutDataCopyWith<$Res> {
  factory _$$CheckoutDataImplCopyWith(
          _$CheckoutDataImpl value, $Res Function(_$CheckoutDataImpl) then) =
      __$$CheckoutDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'checkout_url') String checkoutUrl,
      @JsonKey(name: 'tx_ref') String txRef,
      String? planId,
      double? amount,
      String? currency});
}

/// @nodoc
class __$$CheckoutDataImplCopyWithImpl<$Res>
    extends _$CheckoutDataCopyWithImpl<$Res, _$CheckoutDataImpl>
    implements _$$CheckoutDataImplCopyWith<$Res> {
  __$$CheckoutDataImplCopyWithImpl(
      _$CheckoutDataImpl _value, $Res Function(_$CheckoutDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckoutData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? checkoutUrl = null,
    Object? txRef = null,
    Object? planId = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
  }) {
    return _then(_$CheckoutDataImpl(
      checkoutUrl: null == checkoutUrl
          ? _value.checkoutUrl
          : checkoutUrl // ignore: cast_nullable_to_non_nullable
              as String,
      txRef: null == txRef
          ? _value.txRef
          : txRef // ignore: cast_nullable_to_non_nullable
              as String,
      planId: freezed == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutDataImpl implements _CheckoutData {
  const _$CheckoutDataImpl(
      {@JsonKey(name: 'checkout_url') required this.checkoutUrl,
      @JsonKey(name: 'tx_ref') required this.txRef,
      this.planId,
      this.amount,
      this.currency});

  factory _$CheckoutDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutDataImplFromJson(json);

  @override
  @JsonKey(name: 'checkout_url')
  final String checkoutUrl;
  @override
  @JsonKey(name: 'tx_ref')
  final String txRef;
  @override
  final String? planId;
  @override
  final double? amount;
  @override
  final String? currency;

  @override
  String toString() {
    return 'CheckoutData(checkoutUrl: $checkoutUrl, txRef: $txRef, planId: $planId, amount: $amount, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutDataImpl &&
            (identical(other.checkoutUrl, checkoutUrl) ||
                other.checkoutUrl == checkoutUrl) &&
            (identical(other.txRef, txRef) || other.txRef == txRef) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, checkoutUrl, txRef, planId, amount, currency);

  /// Create a copy of CheckoutData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutDataImplCopyWith<_$CheckoutDataImpl> get copyWith =>
      __$$CheckoutDataImplCopyWithImpl<_$CheckoutDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutDataImplToJson(
      this,
    );
  }
}

abstract class _CheckoutData implements CheckoutData {
  const factory _CheckoutData(
      {@JsonKey(name: 'checkout_url') required final String checkoutUrl,
      @JsonKey(name: 'tx_ref') required final String txRef,
      final String? planId,
      final double? amount,
      final String? currency}) = _$CheckoutDataImpl;

  factory _CheckoutData.fromJson(Map<String, dynamic> json) =
      _$CheckoutDataImpl.fromJson;

  @override
  @JsonKey(name: 'checkout_url')
  String get checkoutUrl;
  @override
  @JsonKey(name: 'tx_ref')
  String get txRef;
  @override
  String? get planId;
  @override
  double? get amount;
  @override
  String? get currency;

  /// Create a copy of CheckoutData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutDataImplCopyWith<_$CheckoutDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyPaymentResponse _$VerifyPaymentResponseFromJson(
    Map<String, dynamic> json) {
  return _VerifyPaymentResponse.fromJson(json);
}

/// @nodoc
mixin _$VerifyPaymentResponse {
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this VerifyPaymentResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyPaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyPaymentResponseCopyWith<VerifyPaymentResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyPaymentResponseCopyWith<$Res> {
  factory $VerifyPaymentResponseCopyWith(VerifyPaymentResponse value,
          $Res Function(VerifyPaymentResponse) then) =
      _$VerifyPaymentResponseCopyWithImpl<$Res, VerifyPaymentResponse>;
  @useResult
  $Res call({String message, Map<String, dynamic>? data});
}

/// @nodoc
class _$VerifyPaymentResponseCopyWithImpl<$Res,
        $Val extends VerifyPaymentResponse>
    implements $VerifyPaymentResponseCopyWith<$Res> {
  _$VerifyPaymentResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyPaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyPaymentResponseImplCopyWith<$Res>
    implements $VerifyPaymentResponseCopyWith<$Res> {
  factory _$$VerifyPaymentResponseImplCopyWith(
          _$VerifyPaymentResponseImpl value,
          $Res Function(_$VerifyPaymentResponseImpl) then) =
      __$$VerifyPaymentResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Map<String, dynamic>? data});
}

/// @nodoc
class __$$VerifyPaymentResponseImplCopyWithImpl<$Res>
    extends _$VerifyPaymentResponseCopyWithImpl<$Res,
        _$VerifyPaymentResponseImpl>
    implements _$$VerifyPaymentResponseImplCopyWith<$Res> {
  __$$VerifyPaymentResponseImplCopyWithImpl(_$VerifyPaymentResponseImpl _value,
      $Res Function(_$VerifyPaymentResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyPaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? data = freezed,
  }) {
    return _then(_$VerifyPaymentResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyPaymentResponseImpl implements _VerifyPaymentResponse {
  const _$VerifyPaymentResponseImpl(
      {required this.message, final Map<String, dynamic>? data})
      : _data = data;

  factory _$VerifyPaymentResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyPaymentResponseImplFromJson(json);

  @override
  final String message;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'VerifyPaymentResponse(message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyPaymentResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_data));

  /// Create a copy of VerifyPaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyPaymentResponseImplCopyWith<_$VerifyPaymentResponseImpl>
      get copyWith => __$$VerifyPaymentResponseImplCopyWithImpl<
          _$VerifyPaymentResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyPaymentResponseImplToJson(
      this,
    );
  }
}

abstract class _VerifyPaymentResponse implements VerifyPaymentResponse {
  const factory _VerifyPaymentResponse(
      {required final String message,
      final Map<String, dynamic>? data}) = _$VerifyPaymentResponseImpl;

  factory _VerifyPaymentResponse.fromJson(Map<String, dynamic> json) =
      _$VerifyPaymentResponseImpl.fromJson;

  @override
  String get message;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of VerifyPaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyPaymentResponseImplCopyWith<_$VerifyPaymentResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AccessInfo _$AccessInfoFromJson(Map<String, dynamic> json) {
  return _AccessInfo.fromJson(json);
}

/// @nodoc
mixin _$AccessInfo {
  bool get hasAccess => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  String? get accessType => throw _privateConstructorUsedError;
  String? get plan => throw _privateConstructorUsedError;
  int get daysLeft => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get requiresPayment => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;

  /// Serializes this AccessInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessInfoCopyWith<AccessInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessInfoCopyWith<$Res> {
  factory $AccessInfoCopyWith(
          AccessInfo value, $Res Function(AccessInfo) then) =
      _$AccessInfoCopyWithImpl<$Res, AccessInfo>;
  @useResult
  $Res call(
      {bool hasAccess,
      bool isPremium,
      String? accessType,
      String? plan,
      int daysLeft,
      DateTime? expiresAt,
      String? message,
      bool requiresPayment,
      String? fullName});
}

/// @nodoc
class _$AccessInfoCopyWithImpl<$Res, $Val extends AccessInfo>
    implements $AccessInfoCopyWith<$Res> {
  _$AccessInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccess = null,
    Object? isPremium = null,
    Object? accessType = freezed,
    Object? plan = freezed,
    Object? daysLeft = null,
    Object? expiresAt = freezed,
    Object? message = freezed,
    Object? requiresPayment = null,
    Object? fullName = freezed,
  }) {
    return _then(_value.copyWith(
      hasAccess: null == hasAccess
          ? _value.hasAccess
          : hasAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      accessType: freezed == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as String?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPayment: null == requiresPayment
          ? _value.requiresPayment
          : requiresPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccessInfoImplCopyWith<$Res>
    implements $AccessInfoCopyWith<$Res> {
  factory _$$AccessInfoImplCopyWith(
          _$AccessInfoImpl value, $Res Function(_$AccessInfoImpl) then) =
      __$$AccessInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasAccess,
      bool isPremium,
      String? accessType,
      String? plan,
      int daysLeft,
      DateTime? expiresAt,
      String? message,
      bool requiresPayment,
      String? fullName});
}

/// @nodoc
class __$$AccessInfoImplCopyWithImpl<$Res>
    extends _$AccessInfoCopyWithImpl<$Res, _$AccessInfoImpl>
    implements _$$AccessInfoImplCopyWith<$Res> {
  __$$AccessInfoImplCopyWithImpl(
      _$AccessInfoImpl _value, $Res Function(_$AccessInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccessInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccess = null,
    Object? isPremium = null,
    Object? accessType = freezed,
    Object? plan = freezed,
    Object? daysLeft = null,
    Object? expiresAt = freezed,
    Object? message = freezed,
    Object? requiresPayment = null,
    Object? fullName = freezed,
  }) {
    return _then(_$AccessInfoImpl(
      hasAccess: null == hasAccess
          ? _value.hasAccess
          : hasAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      accessType: freezed == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as String?,
      plan: freezed == plan
          ? _value.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as String?,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPayment: null == requiresPayment
          ? _value.requiresPayment
          : requiresPayment // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessInfoImpl implements _AccessInfo {
  const _$AccessInfoImpl(
      {this.hasAccess = false,
      this.isPremium = false,
      this.accessType,
      this.plan,
      this.daysLeft = 0,
      this.expiresAt,
      this.message,
      this.requiresPayment = false,
      this.fullName});

  factory _$AccessInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessInfoImplFromJson(json);

  @override
  @JsonKey()
  final bool hasAccess;
  @override
  @JsonKey()
  final bool isPremium;
  @override
  final String? accessType;
  @override
  final String? plan;
  @override
  @JsonKey()
  final int daysLeft;
  @override
  final DateTime? expiresAt;
  @override
  final String? message;
  @override
  @JsonKey()
  final bool requiresPayment;
  @override
  final String? fullName;

  @override
  String toString() {
    return 'AccessInfo(hasAccess: $hasAccess, isPremium: $isPremium, accessType: $accessType, plan: $plan, daysLeft: $daysLeft, expiresAt: $expiresAt, message: $message, requiresPayment: $requiresPayment, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessInfoImpl &&
            (identical(other.hasAccess, hasAccess) ||
                other.hasAccess == hasAccess) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.accessType, accessType) ||
                other.accessType == accessType) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            (identical(other.daysLeft, daysLeft) ||
                other.daysLeft == daysLeft) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.requiresPayment, requiresPayment) ||
                other.requiresPayment == requiresPayment) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasAccess, isPremium, accessType,
      plan, daysLeft, expiresAt, message, requiresPayment, fullName);

  /// Create a copy of AccessInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessInfoImplCopyWith<_$AccessInfoImpl> get copyWith =>
      __$$AccessInfoImplCopyWithImpl<_$AccessInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessInfoImplToJson(
      this,
    );
  }
}

abstract class _AccessInfo implements AccessInfo {
  const factory _AccessInfo(
      {final bool hasAccess,
      final bool isPremium,
      final String? accessType,
      final String? plan,
      final int daysLeft,
      final DateTime? expiresAt,
      final String? message,
      final bool requiresPayment,
      final String? fullName}) = _$AccessInfoImpl;

  factory _AccessInfo.fromJson(Map<String, dynamic> json) =
      _$AccessInfoImpl.fromJson;

  @override
  bool get hasAccess;
  @override
  bool get isPremium;
  @override
  String? get accessType;
  @override
  String? get plan;
  @override
  int get daysLeft;
  @override
  DateTime? get expiresAt;
  @override
  String? get message;
  @override
  bool get requiresPayment;
  @override
  String? get fullName;

  /// Create a copy of AccessInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessInfoImplCopyWith<_$AccessInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
