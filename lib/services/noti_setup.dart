// ignore_for_file: unused_local_variable, avoid_print, unused_element

import 'package:fit_cibus/models/mealplan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Future<void> init() async {
  //   tz.initializeTimeZones();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid);

  //   await _flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     // onSelectNotification: (String? payload) async {
  //     //   if (payload != null) {
  //     //     print('Notification payload: $payload');
  //     //     // Navigate to a specific screen or perform any action
  //     //     // Example: Navigator.of(context).pushNamed('/meal-details', arguments: payload);
  //     //   }
  //     // },
  //   );

  //   // Define notification channel for Android
  //   const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'mealplanid', // ID of the channel
  //     'Meal Plan Notifications', // Name of the channel
  //     description: 'Notifications for meal plans',
  //     importance: Importance.max,
  //     sound: RawResourceAndroidNotificationSound('notification_sound'),
  //   );

  //   await _flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  // }

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Updated iOS Initialization settings using DarwinInitializationSettings
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              // Handle when a notification is received while the app is in the foreground
            });

    // Combine Android and iOS settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS:
          initializationSettingsIOS, // Using DarwinInitializationSettings for iOS
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: (String? payload) async {
      //   if (payload != null) {
      //     print('Notification payload: $payload');
      //     // Navigate to a specific screen or perform any action
      //     // Example: Navigator.of(context).pushNamed('/meal-details', arguments: payload);
      //   }
      // },
    );

    // Define notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'mealplanid', // ID of the channel
      'Meal Plan Notifications', // Name of the channel
      description: 'Notifications for meal plans',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // Permission granted
    } else {
      // Permission denied
    }
  }

  Future<void> scheduleMealPlanNotifications({
    required String mealPlanId,
    required DateTime creationDate,
    required List<Meal> recipeAllocations,
    required List<String> trainees,
  }) async {
    // Notify trainees when a new meal plan is created
    for (var traineeId in trainees) {
      await scheduleNotification(
        id: _generateNotificationId(),
        title: 'New Meal Plan Created',
        body: 'A new meal plan has been created. Check it out!',
        scheduledDate: creationDate,
        payload: 'meal_plan_$mealPlanId',
      );
    }

    // Schedule daily reminders based on recipe allocation
    for (var allocation in recipeAllocations) {
      String allocatedTime = allocation.timeOfDay;
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mealplanid',
            'Meal Plan Notifications',
            channelDescription: 'Notifications for meal plans',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // Disable exact alarms if the platform does not support them
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  int _dayDiff(String day) {
    switch (day) {
      case 'Mon':
        return (DateTime.monday - DateTime.now().weekday + 7) % 7;
      case 'Tue':
        return (DateTime.tuesday - DateTime.now().weekday + 7) % 7;
      case 'Wed':
        return (DateTime.wednesday - DateTime.now().weekday + 7) % 7;
      case 'Thu':
        return (DateTime.thursday - DateTime.now().weekday + 7) % 7;
      case 'Fri':
        return (DateTime.friday - DateTime.now().weekday + 7) % 7;
      case 'Sat':
        return (DateTime.saturday - DateTime.now().weekday + 7) % 7;
      case 'Sun':
        return (DateTime.sunday - DateTime.now().weekday + 7) % 7;
      default:
        return 0;
    }
  }

  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  DateTime _nextInstanceOfDay(DateTime time, String day) {
    DateTime now = DateTime.now();
    int dayDiff = _dayDiff(day);

    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).add(Duration(days: dayDiff));

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 7))
        : scheduledDate;
  }
}
