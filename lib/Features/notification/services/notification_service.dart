// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'dart:io' show Platform;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelId = "meal_reminders_channel";
  static const String channelName = "Meal Reminders";
  static const String channelDescription =
      "This channel is for meal time reminders.";

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('splash');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Pass the user role to this method
  Future<void> scheduleDailyMealReminders(String userRole) async {
    // ignore: unrelated_type_equality_checks
    if (userRole != 1) return; // Only proceed if the user is a trainee (role 1)

    final DateTime now = DateTime.now();

    // Breakfast
    _scheduleMealReminder(
        0,
        "Breakfast Reminder",
        "Your breakfast time is coming up!",
        DateTime(now.year, now.month, now.day, 12, 0));

    // Lunch
    _scheduleMealReminder(1, "Lunch Reminder", "Your lunch time is coming up!",
        DateTime(now.year, now.month, now.day, 12, 0));

    // Dinner
    _scheduleMealReminder(
        2,
        "Dinner Reminder",
        "Your dinner time is coming up!",
        DateTime(now.year, now.month, now.day, 18, 0));
  }

  void _scheduleMealReminder(
      int id, String title, String body, DateTime mealTime) async {
    final DateTime reminder30min =
        mealTime.subtract(const Duration(minutes: 30));
    final DateTime reminder15min =
        mealTime.subtract(const Duration(minutes: 15));

    _scheduleNotification(id, title, body, reminder30min);
    _scheduleNotification(id + 1, title, body, reminder15min);
    _scheduleNotification(id + 2, title, body, mealTime);
  }

  Future<void> _scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    try {
      final tz.TZDateTime tzScheduledTime =
          tz.TZDateTime.from(scheduledTime, tz.local);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  void scheduleBackgroundTask(String userRole) {
    if (Platform.isAndroid && userRole == '0') {
      // Schedule background task for Android using WorkManager
      Workmanager().registerPeriodicTask(
        "1",
        "dailyMealReminder",
        frequency: const Duration(hours: 24),
      );
    } else if (Platform.isIOS && userRole == '0') {
      // iOS-specific background task or fetch (if needed)
      scheduleDailyMealReminders(
          userRole); // iOS can rely on this as it runs every app launch
    }
  }
}
