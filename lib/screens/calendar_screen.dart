import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';

import 'package:voltican_fitness/screens/meal_creation.dart';

// import 'package:voltican_fitness/screens/recipe_grid_screen.dart';
// import 'package:voltican_fitness/widgets/calendar_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Map<String, List<Map<String, dynamic>>> selectedMeals = {};

  void handleSelectionChange(
      Map<String, List<Map<String, dynamic>>> newSelectedMeals) {
    setState(() {
      selectedMeals = newSelectedMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.maxFinite,
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Good Morning ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const Spacer(),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MealCreationScreen(selectedDay: DateTime.now())));
                    },
                    child: const Text(
                      'Add Meal Plan',
                      style: TextStyle(fontSize: 12),
                    )),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TableCalendar(
              firstDay: DateTime.utc(2001, 7, 20),
              focusedDay: focusedDay,
              lastDay: DateTime.utc(2040, 3, 20),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (DateTime focusDay, DateTime selectDay) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MealCreationScreen(selectedDay: selectDay)));
                setState(
                  () {
                    focusedDay = focusDay;
                    selectedDay = selectDay;
                  },
                );
              },
              headerStyle: const HeaderStyle(formatButtonVisible: false),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.black54, height: 10),
            SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today plans",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AllMealPlan())),
                        child: const Text(
                          "View all Plans",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    )));
  }
}
