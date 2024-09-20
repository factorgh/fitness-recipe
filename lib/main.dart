// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:showcaseview/showcaseview.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:voltican_fitness/providers/internet_connect.dart'; // Your connectivity provider
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/onboarding_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/noti_setup.dart'; // Ensure this is the correct import for NotificationService
import 'package:voltican_fitness/utils/hive/hive_meal.dart';
import 'package:voltican_fitness/utils/hive/hive_mealplan.dart';
import 'package:voltican_fitness/utils/hive/hive_recurrence.dart';
import 'package:voltican_fitness/utils/hive/rating.dart';
import 'package:voltican_fitness/utils/hive/hive_recipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get application documents directory for Hive storage
  final appDocDir = await path_provider.getApplicationDocumentsDirectory();

  // Initialize Hive
  await Hive.initFlutter(appDocDir.path);
  await Hive.openBox('testBox');

  // Register Hive adapters
  Hive.registerAdapter(HiveMealAdapter());
  Hive.registerAdapter(HiveMealPlanAdapter());
  Hive.registerAdapter(HiveRecurrenceAdapter());
  Hive.registerAdapter(HiveRecipeAdapter());
  Hive.registerAdapter(RatingAdapter());

  // Initialize Timezone and Notifications
  tz.initializeTimeZones();
  final notificationService = NotificationService();
  await notificationService.init();

  // Request notification permissions
  await notificationService.requestNotificationPermission();

  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final AuthService authService = AuthService();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // Fetch user information on app start
    authService.getMe(context: context, ref: ref);

    // Schedule a test notification
    _scheduleTestNotification();
  }

  // Helper method to show SnackBar
  void showCustomSnackBar(String message, Color color) {
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar() // Hide the current SnackBar
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          // Adjust duration as needed
        ),
      );
  }

  void _scheduleTestNotification() async {
    final notificationService = NotificationService();
    await notificationService.scheduleNotification(
      id: 0,
      title: 'Test Notification',
      body: 'This is a test notification scheduled for 10 seconds from now.',
      scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
      payload: 'test_payload', // Optional payload for handling notifications
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for connectivity changes and show a SnackBar
    ref.listen<ConnectivityState>(connectivityProvider, (previous, next) {
      if (next.isConnected != previous?.isConnected) {
        // Print connection status to console

        print(
            'Connection Status----------------------------------------: ${next.isConnected ? 'Connected' : 'Disconnected'}');

        Future.delayed(Duration.zero, () {
          if (mounted) {
            if (next.isConnected) {
              print('---------------Connected-------------------');
              showCustomSnackBar('Connected to the internet', Colors.green);
            } else {
              print('----------------Disconnected----------------');
              showCustomSnackBar('No internet connection', Colors.red);
            }
          }
        });
      }
    });

    // Watch the user state from the userProvider
    final user = ref.watch(userProvider);

    return ShowCaseWidget(builder: (context) {
      return Builder(builder: (context) {
        return MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            fontFamily: 'Poppins',
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold),
              displayMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 64.0,
                  fontWeight: FontWeight.bold),
              displaySmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold),
              headlineSmall: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
              titleLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16.0),
              bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14.0),
              titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16.0),
              titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 14.0),
              bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12.0),
              labelLarge: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              labelMedium: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                user != null
                    ? TabsScreen(userRole: user.role)
                    : const OnboardingScreen(),
              ],
            ),
          ),
        );
      });
    });
  }
}
