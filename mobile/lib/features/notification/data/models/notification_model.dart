import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String message,
    required String type,
    required bool isRead,
    required DateTime createdAt,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

enum NotificationType {
  subscription,
  payment,
  content,
  system;

  String get displayName {
    switch (this) {
      case NotificationType.subscription:
        return 'Subscription';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.content:
        return 'New Content';
      case NotificationType.system:
        return 'System';
    }
  }
}
