import 'package:dio/dio.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_exception.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<({List<NotificationModel> notifications, int unreadCount})> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> registerDeviceToken(String token, {String platform = 'other'});
  Future<void> removeDeviceToken(String token);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<({List<NotificationModel> notifications, int unreadCount})>
      getNotifications() async {
    try {
      final response = await _dio.get(
        ApiConfig.notifications,
        queryParameters: {'limit': 50, 'skip': 0},
      );
      final data = response.data as Map<String, dynamic>? ?? {};
      final list = (data['notifications'] as List? ?? [])
          .whereType<Map>()
          .map((item) => NotificationModel.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList();
      final unread = (data['unreadCount'] as num?)?.toInt() ??
          list.where((n) => !n.isRead).length;
      return (notifications: list, unreadCount: unread);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('${ApiConfig.notifications}/unread-count');
      return (response.data['unreadCount'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _dio.patch('${ApiConfig.notifications}/$id/read');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.patch('${ApiConfig.notifications}/read-all');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _dio.delete('${ApiConfig.notifications}/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> registerDeviceToken(
    String token, {
    String platform = 'other',
  }) async {
    try {
      await _dio.post(
        '${ApiConfig.notifications}/device-token',
        data: {'token': token, 'platform': platform},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> removeDeviceToken(String token) async {
    try {
      await _dio.delete(
        '${ApiConfig.notifications}/device-token',
        data: {'token': token},
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
