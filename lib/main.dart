import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/onboarding_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/noti_setup.dart'; // Ensure this is the correct import for NotificationService
import 'package:timezone/data/latest.dart' as tz;

import 'package:voltican_fitness/utils/hive/meal.dart';
import 'package:voltican_fitness/utils/hive/mealplan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  // Initialize Timezone and Notifications
  tz.initializeTimeZones();
  final notificationService = NotificationService();
  await notificationService.init();

  // Request permissions
  await notificationService.requestNotificationPermission();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getMe(context: context, ref: ref);

    _scheduleTestNotification();
  }

  void _scheduleTestNotification() async {
    final notificationService = NotificationService();
    await notificationService.scheduleNotification(
      id: 0,
      title: 'Test Notification',
      body: 'This is a test notification scheduled for 10 seconds from now.',
      scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
      payload: 'test_payload', // Optional payload
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider); // Watch the user state

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user != null
          ? TabsScreen(userRole: user.role)
          : const OnboardingScreen(),
    );
  }
}
