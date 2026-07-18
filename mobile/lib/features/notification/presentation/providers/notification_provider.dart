import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../data/services/device_notification_service.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  return NotificationRemoteDataSourceImpl(dio);
});

class NotificationState {
  final List<NotificationModel> items;
  final int unreadCount;
  final bool loading;
  final String? error;

  const NotificationState({
    this.items = const [],
    this.unreadCount = 0,
    this.loading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? items,
    int? unreadCount,
    bool? loading,
    String? error,
  }) {
    return NotificationState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this._ref) : super(const NotificationState());

  final Ref _ref;
  bool _refreshing = false;
  bool _listeningForTokenRefresh = false;

  NotificationRemoteDataSource get _ds =>
      _ref.read(notificationRemoteDataSourceProvider);

  Future<void> refresh({bool notifyDevice = true}) async {
    final user = _ref.read(authStateProvider);
    final guest = _ref.read(guestModeProvider);
    if (user == null || guest) {
      state = const NotificationState();
      return;
    }
    if (_refreshing) return;
    _refreshing = true;
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await _ds.getNotifications();
      state = NotificationState(
        items: result.notifications,
        unreadCount: result.unreadCount,
      );

    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    } finally {
      _refreshing = false;
      if (state.loading) {
        state = state.copyWith(loading: false);
      }
    }
  }

  Future<void> registerDevice() async {
    final user = _ref.read(authStateProvider);
    final guest = _ref.read(guestModeProvider);
    if (user == null || guest) return;
    try {
      await DeviceNotificationService.instance.init();
      final token = await DeviceNotificationService.instance.getDeviceToken();
      if (token == null || token.isEmpty) return;
      await _ds.registerDeviceToken(
        token,
        platform: DeviceNotificationService.instance.platformLabel,
      );
      if (!_listeningForTokenRefresh) {
        _listeningForTokenRefresh = true;
        DeviceNotificationService.instance.onTokenRefresh.listen((newToken) {
          _ds
              .registerDeviceToken(
                newToken,
                platform: DeviceNotificationService.instance.platformLabel,
              )
              .catchError((_) {});
        });
      }
    } catch (e) {
      debugPrint('Device token register failed: $e');
    }
  }

  Future<void> unregisterDevice() async {
    try {
      final token = await DeviceNotificationService.instance.getDeviceToken();
      if (token != null && token.isNotEmpty) {
        await _ds.removeDeviceToken(token);
      }
    } catch (e) {
      debugPrint('Device token removal failed: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    state = state.copyWith(
      items: [
        for (final n in state.items)
          if (n.id == id) n.copyWith(isRead: true) else n,
      ],
      unreadCount: state.items.where((n) => n.id != id && !n.isRead).length,
    );
    try {
      await _ds.markAsRead(id);
    } catch (_) {
      await refresh(notifyDevice: false);
    }
  }

  Future<void> markAllAsRead() async {
    state = state.copyWith(
      items: [for (final n in state.items) n.copyWith(isRead: true)],
      unreadCount: 0,
    );
    try {
      await _ds.markAllAsRead();
    } catch (_) {
      await refresh(notifyDevice: false);
    }
  }

  Future<void> deleteNotification(String id) async {
    final next = state.items.where((n) => n.id != id).toList();
    state = state.copyWith(
      items: next,
      unreadCount: next.where((n) => !n.isRead).length,
    );
    try {
      await _ds.deleteNotification(id);
    } catch (_) {
      await refresh(notifyDevice: false);
    }
  }

  void clear() {
    state = const NotificationState();
  }
}
