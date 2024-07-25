import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/screens/add_meal_screen.dart';
import 'package:voltican_fitness/screens/notifications_screen.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _goToNotification(BuildContext ctx) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const Notifications()));
  }

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
            const SizedBox(height:30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Good Morning',
                  style: TextStyle(fontSize: 22),
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
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/onboarding_1.png")),
                      ),
                    ),
                     const SizedBox(
              width: 5,
            ),
                    const Text('Trainer',style: TextStyle(fontSize: 13,color: Colors.black),),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 3,
                ),
              
                const Spacer(),
               
              ],
            ),
            TableCalendar(
              firstDay: DateTime.utc(2001, 7, 20),
              focusedDay: focusedDay,
              lastDay: DateTime.utc(2040, 3, 20),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (DateTime focusDay, DateTime selectDay) {
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
