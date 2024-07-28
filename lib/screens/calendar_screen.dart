import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/screens/add_meal_screen.dart';
import 'package:voltican_fitness/screens/recipe_grid_screen.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _goToAddMeal(BuildContext ctx) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AddMealScreen()));
  }

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.maxFinite,
      height: double.maxFinite,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('auth_token') ?? '';
                    print(token);
                  },
                  child: const Text(
                    'Good Morning ',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _goToAddMeal(context);
                      },
                      child: const Icon(
                        Icons.add_task_rounded,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Trainer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 3,
                ),
                Spacer(),
              ],
            ),
            TableCalendar(
              firstDay: DateTime.utc(2001, 7, 20),
              focusedDay: focusedDay,
              lastDay: DateTime.utc(2040, 3, 20),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (DateTime focusDay, DateTime selectDay) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RecipeGridScreen()));
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
            const SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "24 April, 2024",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Porched Eggs meal plan",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Baked Salmon with strwaberries",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Baked Salmon with strwaberries",
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
