import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/providers/trainee_mealplans_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/screens/all_meal_plan_trainee.dart';

import 'package:voltican_fitness/widgets/calendar_item.dart';

class CalendarTraineeScreen extends ConsumerStatefulWidget {
  const CalendarTraineeScreen({super.key});

  @override
  ConsumerState<CalendarTraineeScreen> createState() =>
      _CalendarTraineeScreenState();
}

class _CalendarTraineeScreenState extends ConsumerState<CalendarTraineeScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final traineeId = ref.read(userProvider)?.id;
      ref
          .read(traineeMealPlansProvider.notifier)
          .fetchTraineeMealPlans(traineeId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watching the mealPlansProvider
    final mealPlansState = ref.watch(traineeMealPlansProvider);

    final Widget mealPlansWidget;
    if (mealPlansState is MealPlansLoading) {
      mealPlansWidget = const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    } else if (mealPlansState is MealPlansError) {
      mealPlansWidget = Text(mealPlansState.error);
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
                  'Good Morning',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(width: 5),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey[300],
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Trainee',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Current plans",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AllMealPlanTrainee())),
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
