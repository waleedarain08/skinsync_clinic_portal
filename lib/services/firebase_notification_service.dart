import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FireBaseNotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(web: WebInitializationSettings()),
    );

    final webPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          WebFlutterLocalNotificationsPlugin
        >();

    if (webPlugin != null &&
        webPlugin.permissionStatus != WebNotificationPermission.granted) {
      await webPlugin.requestNotificationsPermission();
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });
    log('TOKEN: ${await getToken()}');
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? '';
    final body = notification?.body ?? '';

    final NotificationDetails details = NotificationDetails(
      web: WebNotificationDetails(
        iconUrl: Uri.parse(
          'https://skinsyncai.com/wp-content/uploads/2026/02/logo.png',
        ),
      ),
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  Future<String?> getToken() => _messaging.getToken(
    vapidKey:
        'BCFwKQgRnLkC25FJ7FtUQXZ7qJsV4GcqV-X9wvOujRFwt7mYpT0AoMuEdejrqBUxxPlARQzys5cytkbM7dmxhfo',
  );
}

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // Handle background messages here
}
