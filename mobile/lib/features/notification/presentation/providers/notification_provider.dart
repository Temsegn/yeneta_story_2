import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';

// Mock notification provider - replace with actual API calls
final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationModel>>((ref) {
  return NotificationNotifier();
});

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((n) => !n.isRead).length;
});

class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier() : super([]) {
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    // Mock notifications - replace with API call
    state = [
      NotificationModel(
        id: '1',
        title: 'Welcome to Kids App!',
        message: 'Start your 5-day free trial and explore premium content.',
        type: 'system',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        title: 'New Story Available',
        message: 'Check out "The Magic Forest" - a new adventure awaits!',
        type: 'content',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '3',
        title: 'Trial Ending Soon',
        message: 'Your free trial ends in 3 days. Subscribe to continue enjoying premium content.',
        type: 'subscription',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: true)
        else
          notification
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state)
        notification.copyWith(isRead: true)
    ];
  }

  void deleteNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}
