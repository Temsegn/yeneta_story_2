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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final mapped = Map<String, dynamic>.from(json);
    mapped['id'] = (json['_id'] ?? json['id'] ?? '').toString();
    mapped['isRead'] = json['isRead'] as bool? ?? false;
    mapped['type'] = (json['type'] ?? 'system').toString();
    mapped['title'] = (json['title'] ?? '').toString();
    mapped['message'] = (json['message'] ?? '').toString();
    if (json['createdAt'] != null) {
      mapped['createdAt'] = json['createdAt'].toString();
    } else {
      mapped['createdAt'] = DateTime.now().toIso8601String();
    }
    return _$NotificationModelFromJson(mapped);
  }
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
