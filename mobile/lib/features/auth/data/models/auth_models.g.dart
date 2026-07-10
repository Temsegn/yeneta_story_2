// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      password: json['password'] as String,
      phoneNumber: json['phoneNumber'] as String,
      securityQuestion: json['securityQuestion'] as String,
      securityAnswer: json['securityAnswer'] as String,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      if (instance.email case final value?) 'email': value,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'securityQuestion': instance.securityQuestion,
      'securityAnswer': instance.securityAnswer,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
    };

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordRequestImpl(
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
        _$ForgotPasswordRequestImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
    };

_$ForgotPasswordResponseImpl _$$ForgotPasswordResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordResponseImpl(
      phoneNumber: json['phoneNumber'] as String,
      securityQuestion: json['securityQuestion'] as String,
    );

Map<String, dynamic> _$$ForgotPasswordResponseImplToJson(
        _$ForgotPasswordResponseImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'securityQuestion': instance.securityQuestion,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      phoneNumber: json['phoneNumber'] as String,
      securityAnswer: json['securityAnswer'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'securityAnswer': instance.securityAnswer,
      'newPassword': instance.newPassword,
    };

_$UpdateProfileRequestImpl _$$UpdateProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProfileRequestImpl(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$UpdateProfileRequestImplToJson(
        _$UpdateProfileRequestImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      message: json['message'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      childProfiles: (json['childProfiles'] as List<dynamic>?)
          ?.map((e) => ChildProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'phoneNumber': instance.phoneNumber,
      'childProfiles': instance.childProfiles,
      'isActive': instance.isActive,
    };

_$ChildProfileImpl _$$ChildProfileImplFromJson(Map<String, dynamic> json) =>
    _$ChildProfileImpl(
      name: json['name'] as String,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
    );

Map<String, dynamic> _$$ChildProfileImplToJson(_$ChildProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthdate': instance.birthdate?.toIso8601String(),
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      mongoId: json['_id'] as String?,
      id: json['id'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      childProfiles: (json['childProfiles'] as List<dynamic>?)
          ?.map((e) => ChildProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      '_id': instance.mongoId,
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'phoneNumber': instance.phoneNumber,
      'childProfiles': instance.childProfiles,
      'isActive': instance.isActive,
    };
