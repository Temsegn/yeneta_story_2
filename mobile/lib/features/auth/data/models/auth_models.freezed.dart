// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get securityQuestion => throw _privateConstructorUsedError;
  String get securityAnswer => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String fullName,
      @JsonKey(includeIfNull: false) String? email,
      String password,
      String phoneNumber,
      String securityQuestion,
      String securityAnswer});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = freezed,
    Object? password = null,
    Object? phoneNumber = null,
    Object? securityQuestion = null,
    Object? securityAnswer = null,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityQuestion: null == securityQuestion
          ? _value.securityQuestion
          : securityQuestion // ignore: cast_nullable_to_non_nullable
              as String,
      securityAnswer: null == securityAnswer
          ? _value.securityAnswer
          : securityAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fullName,
      @JsonKey(includeIfNull: false) String? email,
      String password,
      String phoneNumber,
      String securityQuestion,
      String securityAnswer});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = freezed,
    Object? password = null,
    Object? phoneNumber = null,
    Object? securityQuestion = null,
    Object? securityAnswer = null,
  }) {
    return _then(_$RegisterRequestImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityQuestion: null == securityQuestion
          ? _value.securityQuestion
          : securityQuestion // ignore: cast_nullable_to_non_nullable
              as String,
      securityAnswer: null == securityAnswer
          ? _value.securityAnswer
          : securityAnswer // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.fullName,
      @JsonKey(includeIfNull: false) this.email,
      required this.password,
      required this.phoneNumber,
      required this.securityQuestion,
      required this.securityAnswer});

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String fullName;
  @override
  @JsonKey(includeIfNull: false)
  final String? email;
  @override
  final String password;
  @override
  final String phoneNumber;
  @override
  final String securityQuestion;
  @override
  final String securityAnswer;

  @override
  String toString() {
    return 'RegisterRequest(fullName: $fullName, email: $email, password: $password, phoneNumber: $phoneNumber, securityQuestion: $securityQuestion, securityAnswer: $securityAnswer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.securityQuestion, securityQuestion) ||
                other.securityQuestion == securityQuestion) &&
            (identical(other.securityAnswer, securityAnswer) ||
                other.securityAnswer == securityAnswer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, email, password,
      phoneNumber, securityQuestion, securityAnswer);

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String fullName,
      @JsonKey(includeIfNull: false) final String? email,
      required final String password,
      required final String phoneNumber,
      required final String securityQuestion,
      required final String securityAnswer}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get fullName;
  @override
  @JsonKey(includeIfNull: false)
  String? get email;
  @override
  String get password;
  @override
  String get phoneNumber;
  @override
  String get securityQuestion;
  @override
  String get securityAnswer;

  /// Create a copy of RegisterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String phoneNumber, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? password = null,
  }) {
    return _then(_$LoginRequestImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.phoneNumber, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginRequest(phoneNumber: $phoneNumber, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, password);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String phoneNumber,
      required final String password}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get password;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordRequest {
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordRequestCopyWith<ForgotPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordRequestCopyWith<$Res> {
  factory $ForgotPasswordRequestCopyWith(ForgotPasswordRequest value,
          $Res Function(ForgotPasswordRequest) then) =
      _$ForgotPasswordRequestCopyWithImpl<$Res, ForgotPasswordRequest>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class _$ForgotPasswordRequestCopyWithImpl<$Res,
        $Val extends ForgotPasswordRequest>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  _$ForgotPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordRequestImplCopyWith<$Res>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  factory _$$ForgotPasswordRequestImplCopyWith(
          _$ForgotPasswordRequestImpl value,
          $Res Function(_$ForgotPasswordRequestImpl) then) =
      __$$ForgotPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$ForgotPasswordRequestImplCopyWithImpl<$Res>
    extends _$ForgotPasswordRequestCopyWithImpl<$Res,
        _$ForgotPasswordRequestImpl>
    implements _$$ForgotPasswordRequestImplCopyWith<$Res> {
  __$$ForgotPasswordRequestImplCopyWithImpl(_$ForgotPasswordRequestImpl _value,
      $Res Function(_$ForgotPasswordRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
  }) {
    return _then(_$ForgotPasswordRequestImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordRequestImpl implements _ForgotPasswordRequest {
  const _$ForgotPasswordRequestImpl({required this.phoneNumber});

  factory _$ForgotPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordRequestImplFromJson(json);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'ForgotPasswordRequest(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordRequestImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
      get copyWith => __$$ForgotPasswordRequestImplCopyWithImpl<
          _$ForgotPasswordRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordRequest implements ForgotPasswordRequest {
  const factory _ForgotPasswordRequest({required final String phoneNumber}) =
      _$ForgotPasswordRequestImpl;

  factory _ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordRequestImpl.fromJson;

  @override
  String get phoneNumber;

  /// Create a copy of ForgotPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordResponse.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordResponse {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get securityQuestion => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordResponseCopyWith<ForgotPasswordResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordResponseCopyWith<$Res> {
  factory $ForgotPasswordResponseCopyWith(ForgotPasswordResponse value,
          $Res Function(ForgotPasswordResponse) then) =
      _$ForgotPasswordResponseCopyWithImpl<$Res, ForgotPasswordResponse>;
  @useResult
  $Res call({String phoneNumber, String securityQuestion});
}

/// @nodoc
class _$ForgotPasswordResponseCopyWithImpl<$Res,
        $Val extends ForgotPasswordResponse>
    implements $ForgotPasswordResponseCopyWith<$Res> {
  _$ForgotPasswordResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? securityQuestion = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityQuestion: null == securityQuestion
          ? _value.securityQuestion
          : securityQuestion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordResponseImplCopyWith<$Res>
    implements $ForgotPasswordResponseCopyWith<$Res> {
  factory _$$ForgotPasswordResponseImplCopyWith(
          _$ForgotPasswordResponseImpl value,
          $Res Function(_$ForgotPasswordResponseImpl) then) =
      __$$ForgotPasswordResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String securityQuestion});
}

/// @nodoc
class __$$ForgotPasswordResponseImplCopyWithImpl<$Res>
    extends _$ForgotPasswordResponseCopyWithImpl<$Res,
        _$ForgotPasswordResponseImpl>
    implements _$$ForgotPasswordResponseImplCopyWith<$Res> {
  __$$ForgotPasswordResponseImplCopyWithImpl(
      _$ForgotPasswordResponseImpl _value,
      $Res Function(_$ForgotPasswordResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? securityQuestion = null,
  }) {
    return _then(_$ForgotPasswordResponseImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityQuestion: null == securityQuestion
          ? _value.securityQuestion
          : securityQuestion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordResponseImpl implements _ForgotPasswordResponse {
  const _$ForgotPasswordResponseImpl(
      {required this.phoneNumber, required this.securityQuestion});

  factory _$ForgotPasswordResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordResponseImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String securityQuestion;

  @override
  String toString() {
    return 'ForgotPasswordResponse(phoneNumber: $phoneNumber, securityQuestion: $securityQuestion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordResponseImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.securityQuestion, securityQuestion) ||
                other.securityQuestion == securityQuestion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, securityQuestion);

  /// Create a copy of ForgotPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordResponseImplCopyWith<_$ForgotPasswordResponseImpl>
      get copyWith => __$$ForgotPasswordResponseImplCopyWithImpl<
          _$ForgotPasswordResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordResponseImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordResponse implements ForgotPasswordResponse {
  const factory _ForgotPasswordResponse(
      {required final String phoneNumber,
      required final String securityQuestion}) = _$ForgotPasswordResponseImpl;

  factory _ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordResponseImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get securityQuestion;

  /// Create a copy of ForgotPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordResponseImplCopyWith<_$ForgotPasswordResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(Map<String, dynamic> json) {
  return _ResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordRequest {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get securityAnswer => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  /// Serializes this ResetPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(ResetPasswordRequest value,
          $Res Function(ResetPasswordRequest) then) =
      _$ResetPasswordRequestCopyWithImpl<$Res, ResetPasswordRequest>;
  @useResult
  $Res call({String phoneNumber, String securityAnswer, String newPassword});
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<$Res,
        $Val extends ResetPasswordRequest>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? securityAnswer = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityAnswer: null == securityAnswer
          ? _value.securityAnswer
          : securityAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPasswordRequestImplCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$$ResetPasswordRequestImplCopyWith(_$ResetPasswordRequestImpl value,
          $Res Function(_$ResetPasswordRequestImpl) then) =
      __$$ResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String securityAnswer, String newPassword});
}

/// @nodoc
class __$$ResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$ResetPasswordRequestCopyWithImpl<$Res, _$ResetPasswordRequestImpl>
    implements _$$ResetPasswordRequestImplCopyWith<$Res> {
  __$$ResetPasswordRequestImplCopyWithImpl(_$ResetPasswordRequestImpl _value,
      $Res Function(_$ResetPasswordRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? securityAnswer = null,
    Object? newPassword = null,
  }) {
    return _then(_$ResetPasswordRequestImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      securityAnswer: null == securityAnswer
          ? _value.securityAnswer
          : securityAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordRequestImpl implements _ResetPasswordRequest {
  const _$ResetPasswordRequestImpl(
      {required this.phoneNumber,
      required this.securityAnswer,
      required this.newPassword});

  factory _$ResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordRequestImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String securityAnswer;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'ResetPasswordRequest(phoneNumber: $phoneNumber, securityAnswer: $securityAnswer, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordRequestImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.securityAnswer, securityAnswer) ||
                other.securityAnswer == securityAnswer) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneNumber, securityAnswer, newPassword);

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith =>
          __$$ResetPasswordRequestImplCopyWithImpl<_$ResetPasswordRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ResetPasswordRequest implements ResetPasswordRequest {
  const factory _ResetPasswordRequest(
      {required final String phoneNumber,
      required final String securityAnswer,
      required final String newPassword}) = _$ResetPasswordRequestImpl;

  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordRequestImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get securityAnswer;
  @override
  String get newPassword;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateProfileRequest _$UpdateProfileRequestFromJson(Map<String, dynamic> json) {
  return _UpdateProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateProfileRequest {
  String? get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this UpdateProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProfileRequestCopyWith<UpdateProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileRequestCopyWith<$Res> {
  factory $UpdateProfileRequestCopyWith(UpdateProfileRequest value,
          $Res Function(UpdateProfileRequest) then) =
      _$UpdateProfileRequestCopyWithImpl<$Res, UpdateProfileRequest>;
  @useResult
  $Res call({String? fullName, String? email, String? phoneNumber});
}

/// @nodoc
class _$UpdateProfileRequestCopyWithImpl<$Res,
        $Val extends UpdateProfileRequest>
    implements $UpdateProfileRequestCopyWith<$Res> {
  _$UpdateProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProfileRequestImplCopyWith<$Res>
    implements $UpdateProfileRequestCopyWith<$Res> {
  factory _$$UpdateProfileRequestImplCopyWith(_$UpdateProfileRequestImpl value,
          $Res Function(_$UpdateProfileRequestImpl) then) =
      __$$UpdateProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? fullName, String? email, String? phoneNumber});
}

/// @nodoc
class __$$UpdateProfileRequestImplCopyWithImpl<$Res>
    extends _$UpdateProfileRequestCopyWithImpl<$Res, _$UpdateProfileRequestImpl>
    implements _$$UpdateProfileRequestImplCopyWith<$Res> {
  __$$UpdateProfileRequestImplCopyWithImpl(_$UpdateProfileRequestImpl _value,
      $Res Function(_$UpdateProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_$UpdateProfileRequestImpl(
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProfileRequestImpl implements _UpdateProfileRequest {
  const _$UpdateProfileRequestImpl(
      {this.fullName, this.email, this.phoneNumber});

  factory _$UpdateProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProfileRequestImplFromJson(json);

  @override
  final String? fullName;
  @override
  final String? email;
  @override
  final String? phoneNumber;

  @override
  String toString() {
    return 'UpdateProfileRequest(fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileRequestImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, email, phoneNumber);

  /// Create a copy of UpdateProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileRequestImplCopyWith<_$UpdateProfileRequestImpl>
      get copyWith =>
          __$$UpdateProfileRequestImplCopyWithImpl<_$UpdateProfileRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateProfileRequest implements UpdateProfileRequest {
  const factory _UpdateProfileRequest(
      {final String? fullName,
      final String? email,
      final String? phoneNumber}) = _$UpdateProfileRequestImpl;

  factory _UpdateProfileRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateProfileRequestImpl.fromJson;

  @override
  String? get fullName;
  @override
  String? get email;
  @override
  String? get phoneNumber;

  /// Create a copy of UpdateProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProfileRequestImplCopyWith<_$UpdateProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  String get message => throw _privateConstructorUsedError;
  UserData get user => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call({String message, UserData user});

  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
    ) as $Val);
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get user {
    return $UserDataCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, UserData user});

  @override
  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? user = null,
  }) {
    return _then(_$AuthResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl({required this.message, required this.user});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final String message;
  @override
  final UserData user;

  @override
  String toString() {
    return 'AuthResponse(message: $message, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, user);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {required final String message,
      required final UserData user}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  String get message;
  @override
  UserData get user;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  List<ChildProfile>? get childProfiles => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String id,
      String fullName,
      String? email,
      String role,
      String? phoneNumber,
      List<ChildProfile>? childProfiles,
      bool? isActive});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? role = null,
    Object? phoneNumber = freezed,
    Object? childProfiles = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      childProfiles: freezed == childProfiles
          ? _value.childProfiles
          : childProfiles // ignore: cast_nullable_to_non_nullable
              as List<ChildProfile>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fullName,
      String? email,
      String role,
      String? phoneNumber,
      List<ChildProfile>? childProfiles,
      bool? isActive});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? role = null,
    Object? phoneNumber = freezed,
    Object? childProfiles = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$UserDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      childProfiles: freezed == childProfiles
          ? _value._childProfiles
          : childProfiles // ignore: cast_nullable_to_non_nullable
              as List<ChildProfile>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl implements _UserData {
  const _$UserDataImpl(
      {required this.id,
      required this.fullName,
      this.email,
      required this.role,
      this.phoneNumber,
      final List<ChildProfile>? childProfiles,
      this.isActive})
      : _childProfiles = childProfiles;

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String role;
  @override
  final String? phoneNumber;
  final List<ChildProfile>? _childProfiles;
  @override
  List<ChildProfile>? get childProfiles {
    final value = _childProfiles;
    if (value == null) return null;
    if (_childProfiles is EqualUnmodifiableListView) return _childProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isActive;

  @override
  String toString() {
    return 'UserData(id: $id, fullName: $fullName, email: $email, role: $role, phoneNumber: $phoneNumber, childProfiles: $childProfiles, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality()
                .equals(other._childProfiles, _childProfiles) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fullName,
      email,
      role,
      phoneNumber,
      const DeepCollectionEquality().hash(_childProfiles),
      isActive);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData implements UserData {
  const factory _UserData(
      {required final String id,
      required final String fullName,
      final String? email,
      required final String role,
      final String? phoneNumber,
      final List<ChildProfile>? childProfiles,
      final bool? isActive}) = _$UserDataImpl;

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String get id;
  @override
  String get fullName;
  @override
  String? get email;
  @override
  String get role;
  @override
  String? get phoneNumber;
  @override
  List<ChildProfile>? get childProfiles;
  @override
  bool? get isActive;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) {
  return _ChildProfile.fromJson(json);
}

/// @nodoc
mixin _$ChildProfile {
  String get name => throw _privateConstructorUsedError;
  DateTime? get birthdate => throw _privateConstructorUsedError;

  /// Serializes this ChildProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildProfileCopyWith<ChildProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildProfileCopyWith<$Res> {
  factory $ChildProfileCopyWith(
          ChildProfile value, $Res Function(ChildProfile) then) =
      _$ChildProfileCopyWithImpl<$Res, ChildProfile>;
  @useResult
  $Res call({String name, DateTime? birthdate});
}

/// @nodoc
class _$ChildProfileCopyWithImpl<$Res, $Val extends ChildProfile>
    implements $ChildProfileCopyWith<$Res> {
  _$ChildProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? birthdate = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: freezed == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChildProfileImplCopyWith<$Res>
    implements $ChildProfileCopyWith<$Res> {
  factory _$$ChildProfileImplCopyWith(
          _$ChildProfileImpl value, $Res Function(_$ChildProfileImpl) then) =
      __$$ChildProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, DateTime? birthdate});
}

/// @nodoc
class __$$ChildProfileImplCopyWithImpl<$Res>
    extends _$ChildProfileCopyWithImpl<$Res, _$ChildProfileImpl>
    implements _$$ChildProfileImplCopyWith<$Res> {
  __$$ChildProfileImplCopyWithImpl(
      _$ChildProfileImpl _value, $Res Function(_$ChildProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? birthdate = freezed,
  }) {
    return _then(_$ChildProfileImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: freezed == birthdate
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildProfileImpl implements _ChildProfile {
  const _$ChildProfileImpl({required this.name, this.birthdate});

  factory _$ChildProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildProfileImplFromJson(json);

  @override
  final String name;
  @override
  final DateTime? birthdate;

  @override
  String toString() {
    return 'ChildProfile(name: $name, birthdate: $birthdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildProfileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, birthdate);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      __$$ChildProfileImplCopyWithImpl<_$ChildProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildProfileImplToJson(
      this,
    );
  }
}

abstract class _ChildProfile implements ChildProfile {
  const factory _ChildProfile(
      {required final String name,
      final DateTime? birthdate}) = _$ChildProfileImpl;

  factory _ChildProfile.fromJson(Map<String, dynamic> json) =
      _$ChildProfileImpl.fromJson;

  @override
  String get name;
  @override
  DateTime? get birthdate;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @JsonKey(name: '_id')
  String? get mongoId => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  List<ChildProfile>? get childProfiles => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? mongoId,
      String? id,
      String fullName,
      String? email,
      String role,
      String? phoneNumber,
      List<ChildProfile>? childProfiles,
      bool? isActive});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mongoId = freezed,
    Object? id = freezed,
    Object? fullName = null,
    Object? email = freezed,
    Object? role = null,
    Object? phoneNumber = freezed,
    Object? childProfiles = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      mongoId: freezed == mongoId
          ? _value.mongoId
          : mongoId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      childProfiles: freezed == childProfiles
          ? _value.childProfiles
          : childProfiles // ignore: cast_nullable_to_non_nullable
              as List<ChildProfile>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? mongoId,
      String? id,
      String fullName,
      String? email,
      String role,
      String? phoneNumber,
      List<ChildProfile>? childProfiles,
      bool? isActive});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mongoId = freezed,
    Object? id = freezed,
    Object? fullName = null,
    Object? email = freezed,
    Object? role = null,
    Object? phoneNumber = freezed,
    Object? childProfiles = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$UserProfileImpl(
      mongoId: freezed == mongoId
          ? _value.mongoId
          : mongoId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      childProfiles: freezed == childProfiles
          ? _value._childProfiles
          : childProfiles // ignore: cast_nullable_to_non_nullable
              as List<ChildProfile>?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {@JsonKey(name: '_id') this.mongoId,
      this.id,
      required this.fullName,
      this.email,
      required this.role,
      this.phoneNumber,
      final List<ChildProfile>? childProfiles,
      this.isActive})
      : _childProfiles = childProfiles;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? mongoId;
  @override
  final String? id;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String role;
  @override
  final String? phoneNumber;
  final List<ChildProfile>? _childProfiles;
  @override
  List<ChildProfile>? get childProfiles {
    final value = _childProfiles;
    if (value == null) return null;
    if (_childProfiles is EqualUnmodifiableListView) return _childProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isActive;

  @override
  String toString() {
    return 'UserProfile(mongoId: $mongoId, id: $id, fullName: $fullName, email: $email, role: $role, phoneNumber: $phoneNumber, childProfiles: $childProfiles, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.mongoId, mongoId) || other.mongoId == mongoId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            const DeepCollectionEquality()
                .equals(other._childProfiles, _childProfiles) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mongoId,
      id,
      fullName,
      email,
      role,
      phoneNumber,
      const DeepCollectionEquality().hash(_childProfiles),
      isActive);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {@JsonKey(name: '_id') final String? mongoId,
      final String? id,
      required final String fullName,
      final String? email,
      required final String role,
      final String? phoneNumber,
      final List<ChildProfile>? childProfiles,
      final bool? isActive}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get mongoId;
  @override
  String? get id;
  @override
  String get fullName;
  @override
  String? get email;
  @override
  String get role;
  @override
  String? get phoneNumber;
  @override
  List<ChildProfile>? get childProfiles;
  @override
  bool? get isActive;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
