import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';
import '../../data/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Workmanager _workmanager = Workmanager();

  NotificationService._internal();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    await requestNotificationPermissions();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const windowsSettings = WindowsInitializationSettings(
      appName: 'Flutter Resto',
      appUserModelId: 'com.igz.flutter_resto',
      guid: '79460d60-c1c4-45e8-be40-b5043fc6eea6',
      iconPath: 'flutter_logo',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );

    await _notifications.initialize(initSettings);

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await _workmanager.initialize(callbackDispatcher);
    }
  }

  Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> scheduleDailyReminder() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await _workmanager.registerPeriodicTask(
        'daily-reminder',
        'showRestaurantReminder',
        frequency: const Duration(days: 1),
        initialDelay: _getInitialDelay(),
        constraints: Constraints(networkType: NetworkType.connected),
      );
    }
  }

  Future<void> cancelDailyReminder() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await _workmanager.cancelByUniqueName('daily-reminder');
    }
  }

  Duration _getInitialDelay() {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 11, 0);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime.difference(now);
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'restaurant_reminder',
      'Restaurant Reminder',
      channelDescription: 'Daily restaurant reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(0, title, body, details);
  }
}
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'showRestaurantReminder') {
      final notificationService = NotificationService();
      final apiService = ApiService();

      try {
        final restaurants = await apiService.getRestaurants();
        if (restaurants.isNotEmpty) {
          final random = Random();
          final randomRestaurant =
              restaurants[random.nextInt(restaurants.length)];
          await notificationService.showNotification(
            title: 'Lunch Time! 🍽️',
            body:
                'Let\'s try ${randomRestaurant.name} at ${randomRestaurant.city} today!',
          );
        } else {
          // Fallback jika tidak ada restoran
          await notificationService.showNotification(
            title: 'Lunch Time! 🍽️',
            body: 'Time to find a great restaurant for your lunch!',
          );
        }
      } catch (e) {
        debugPrint('Error fetching restaurants for notification: $e');
        // Fallback jika terjadi error
        await notificationService.showNotification(
          title: 'Lunch Time! 🍽️',
          body: 'Time to find a great restaurant for your lunch!',
        );
      }
    }
    return true;
  });
}
