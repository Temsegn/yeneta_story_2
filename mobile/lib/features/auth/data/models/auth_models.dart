import 'package:freezed_annotation/freezed_annotation.dart';

// Freezed places JsonKey on factory params; analyzer warning is expected.
// ignore_for_file: invalid_annotation_target

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String fullName,
    @JsonKey(includeIfNull: false) String? email,
    required String password,
    required String phoneNumber,
    required String securityQuestion,
    required String securityAnswer,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phoneNumber,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({
    required String phoneNumber,
  }) = _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
}

@freezed
class ForgotPasswordResponse with _$ForgotPasswordResponse {
  const factory ForgotPasswordResponse({
    required String phoneNumber,
    required String securityQuestion,
  }) = _ForgotPasswordResponse;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);
}

@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String phoneNumber,
    required String securityAnswer,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    String? fullName,
    String? email,
    String? phoneNumber,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String message,
    required UserData user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String fullName,
    String? email,
    required String role,
    String? phoneNumber,
    List<ChildProfile>? childProfiles,
    bool? isActive,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@freezed
class ChildProfile with _$ChildProfile {
  const factory ChildProfile({
    required String name,
    DateTime? birthdate,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: '_id') String? mongoId,
    String? id,
    required String fullName,
    String? email,
    required String role,
    String? phoneNumber,
    List<ChildProfile>? childProfiles,
    bool? isActive,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
