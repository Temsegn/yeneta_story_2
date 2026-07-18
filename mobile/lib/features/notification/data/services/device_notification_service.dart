import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// Firebase is delivery-only. Notification records remain in the backend.
class DeviceNotificationService {
  DeviceNotificationService._();
  static final DeviceNotificationService instance =
      DeviceNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _firebaseReady = false;

  static const _channelId = 'yeneta_alerts';
  static const _channelName = 'Yeneta Alerts';

  Future<void> init() async {
    if (_ready) return;

    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );
      _firebaseReady = true;
    } catch (error) {
      debugPrint(
        'Firebase is not configured yet. Add google-services.json / '
        'GoogleService-Info.plist: $error',
      );
    }

    if (!kIsWeb) {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: ios),
      );

      if (defaultTargetPlatform == TargetPlatform.android) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(
              const AndroidNotificationChannel(
                _channelId,
                _channelName,
                description: 'Yeneta Story alerts and reminders',
                importance: Importance.high,
              ),
            );
        await Permission.notification.request();
      }
    }

    if (_firebaseReady) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification == null) return;
        show(
          title: notification.title ?? 'Yeneta Story',
          body: notification.body ?? '',
          id: message.messageId.hashCode,
        );
      });
    }
    _ready = true;
  }

  Future<String?> getDeviceToken() async {
    if (!_ready) await init();
    if (!_firebaseReady) return null;
    return FirebaseMessaging.instance.getToken();
  }

  Stream<String> get onTokenRefresh =>
      _firebaseReady ? FirebaseMessaging.instance.onTokenRefresh : const Stream.empty();

  String get platformLabel {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'other';
    }
  }

  Future<void> show({
    required String title,
    required String body,
    int id = 0,
  }) async {
    if (kIsWeb) {
      debugPrint('Web notification: $title — $body');
      return;
    }
    if (!_ready) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Yeneta Story alerts and reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      id: id == 0 ? DateTime.now().millisecondsSinceEpoch % 100000 : id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
