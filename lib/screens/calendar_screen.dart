import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';
import 'package:voltican_fitness/screens/meal_creation.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mealPlansProvider.notifier).fetchAllMealPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;

    // Watching the mealPlansProvider
    final mealPlansState = ref.watch(mealPlansProvider);

    // Handling different states of meal plans
    final Widget mealPlansWidget;
    if (mealPlansState is MealPlansLoading) {
      // ignore: prefer_const_constructors
      mealPlansWidget = Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        )),
      );
    } else if (mealPlansState is MealPlansError) {
      mealPlansWidget = const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: Text("No meal plans available")),
      );
    } else if (mealPlansState is MealPlansLoaded) {
      final mealPlans = mealPlansState.mealPlans;

      // Get the first 3 meal plans or fewer if there are less than 3
      final firstThreeMealPlans = mealPlans.take(3).toList();

      mealPlansWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          const SizedBox(height: 10),
          // Displaying the first 3 meal plans
          for (var mealPlan in firstThreeMealPlans) ...[
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: mealPlan,
            ),
            const SizedBox(height: 20),
          ],
        ],
      );
    } else {
      mealPlansWidget = const Text('No meal plans available.');
    }

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
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 30),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Latest plans",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AllMealPlan())),
                  child: const Text(
                    "View all Plans",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(child: mealPlansWidget),
            ),
          ],
        ),
      ),
    )));
  }
}
