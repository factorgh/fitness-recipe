import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/notification/services/notification_service.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/onboarding_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Timezone and Notifications inside the callback
    tz.initializeTimeZones();
    await NotificationService().init();

    // Schedule reminders
    await NotificationService().scheduleDailyMealReminders("0");

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Timezone and Notifications
  tz.initializeTimeZones();
  await NotificationService().init();

  // Initialize WorkManager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

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
