import 'package:fit_cibus/Features/notification/services/notification_service.dart';
import 'package:fit_cibus/screens/calendar_screen.dart';
import 'package:fit_cibus/screens/calendar_trainee_screen.dart';
import 'package:fit_cibus/screens/recipes_screen.dart';
import 'package:fit_cibus/screens/settings_screen.dart';
import 'package:fit_cibus/screens/trainee_landing_screen.dart';
import 'package:fit_cibus/screens/trainee_recipe_screen.dart';
import 'package:fit_cibus/screens/trainee_settings_screen.dart';
import 'package:fit_cibus/screens/trainees_screen.dart';
import 'package:fit_cibus/screens/trainer_landing_screen.dart';
import 'package:fit_cibus/screens/trainer_search.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  final String userRole; // Pass user role to the widget

  const TabsScreen({super.key, required this.userRole});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _activePageIndex = 0;

  // Define navigation items based on user role
  List<BottomNavigationBarItem> get _bottomNavBarItems {
    if (widget.userRole == '0') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Meal Plans', // Extra tab for role 0
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Search', // Extra tab for role 0
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_3),
          label: 'Trainees',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    }
  }

  // Define pages based on user role
  List<Widget> get _pages {
    if (widget.userRole == '0') {
      return [
        const TraineeLandingScreen(),
        const TraineeRecipeScreen(),
        const CalendarTraineeScreen(),
        const TrainerSearchScreen(),
        const TraineeSettingsScreen()
      ];
    } else {
      return const [
        TrainerLandingScreen(),
        MealPlanScreen(),
        CalendarScreen(),
        TraineesScreen(),
        SettingsScreen(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // schedule background notification task here
    NotificationService().scheduleBackgroundTask(widget.userRole);
    return Scaffold(
      body: IndexedStack(
        index: _activePageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _activePageIndex,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.redAccent,
        backgroundColor: const Color.fromARGB(255, 233, 242, 246),
        items: _bottomNavBarItems,
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _activePageIndex = index;
    });
  }
}
