import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/calendar_screen.dart';
import 'package:voltican_fitness/screens/meal_plan_screen.dart';
import 'package:voltican_fitness/screens/settings_screen.dart';
import 'package:voltican_fitness/screens/trainees_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int activePageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CalendarScreen();

    if (activePageIndex == 1) {
      activePage = const MealPlanScreen();
    }
    if (activePageIndex == 2) {
      activePage = const TraineesScreen();
    }
    if (activePageIndex == 3) {
      activePage = const SettingsScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: activePageIndex,
        unselectedItemColor: Colors.black54,
        unselectedLabelStyle: const TextStyle(color: Colors.black54),
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'MealPlans'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_3), label: 'Trainees'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
