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
  int _activePageIndex = 0;

  final List<Widget> _pages = const [
    CalendarScreen(),
    MealPlanScreen(),
    TraineesScreen(),
    SettingsScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      _activePageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _activePageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _activePageIndex,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.red,
        backgroundColor: Colors.blueGrey[900], // Set the background color here
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_3),
            label: 'Trainees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
