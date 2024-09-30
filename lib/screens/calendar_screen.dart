import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';
import 'package:voltican_fitness/screens/meal_creation.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';
import 'package:voltican_fitness/providers/calendar_mealplan_prov.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the mealPlanProvider
    final mealPlansState = ref.watch(mealPlanProvider);
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;

    Widget mealPlansWidget;

    mealPlansWidget = mealPlansState.when(
      data: (mealPlans) {
        if (mealPlans.isEmpty) {
          return const Text('No meal plans available.');
        }
        final firstThreeMealPlans = mealPlans.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            for (var mealPlan in firstThreeMealPlans) ...[
              CalendarItem(
                titleIcon: Icons.restaurant_menu,
                mealPlan: mealPlan,
              ),
              const SizedBox(height: 20),
            ],
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.red)),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(child: Text(error.toString())),
      ),
    );

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
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => MealCreationScreen(
                                    selectedDay: DateTime.now()),
                              ),
                            )
                            .then((_) => ref
                                .read(mealPlanProvider.notifier)
                                .fetchMealPlans());
                      },
                      child: const Text(
                        'Add Meal Plan',
                        style: TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 20),
                TableCalendar(
                  firstDay: DateTime.utc(2001, 7, 20),
                  focusedDay: focusedDay,
                  lastDay: DateTime.utc(2040, 3, 20),
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  onDaySelected: (DateTime focusDay, DateTime selectDay) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MealCreationScreen(selectedDay: selectDay),
                          ),
                        )
                        .then((_) => ref
                            .read(mealPlanProvider.notifier)
                            .fetchMealPlans());
                    focusedDay = focusDay;
                    selectedDay = selectDay;
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllMealPlan(),
                        ),
                      ),
                      child: const Text(
                        "View all Plans",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: mealPlansWidget,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
