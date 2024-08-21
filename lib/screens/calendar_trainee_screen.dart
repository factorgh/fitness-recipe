// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/models/mealplan.dart';

import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/providers/trainee_mealplans_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

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

  Map<DateTime, List<MealPlan>> mealPlansByDate = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final traineeId = ref.read(userProvider)?.id;
      if (traineeId != null) {
        ref
            .read(traineeMealPlansProvider.notifier)
            .fetchTraineeMealPlans(traineeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealPlansState = ref.watch(traineeMealPlansProvider);

    if (mealPlansState is MealPlansLoaded) {
      final mealPlans = mealPlansState.mealPlans;

      // Populate mealPlansByDate map, filtering out plans with null dates
      mealPlansByDate = {};
      for (var mealPlan in mealPlans) {
        if (mealPlan.startDate != null && mealPlan.endDate != null) {
          DateTime currentDate = mealPlan.startDate!;
          while (!currentDate.isAfter(mealPlan.endDate!)) {
            if (!mealPlansByDate.containsKey(currentDate)) {
              mealPlansByDate[currentDate] = [];
            }
            mealPlansByDate[currentDate]!.add(mealPlan);
            currentDate = currentDate.add(const Duration(days: 1));
          }
        } else {
          // Handle meal plans with null start or end dates if needed
          // For example, you can log or display a message
          print('Meal plan with null start or end date found: ${mealPlan.id}');
        }
      }
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
            TableCalendar(
              firstDay: DateTime.utc(2001, 7, 20),
              focusedDay: focusedDay,
              lastDay: DateTime.utc(2040, 3, 20),
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              onDaySelected: (DateTime focusDay, DateTime selectDay) {
                setState(() {
                  focusedDay = focusDay;
                  selectedDay = selectDay;
                });
              },
              headerStyle: const HeaderStyle(formatButtonVisible: false),
              calendarBuilders: CalendarBuilders(
                // Highlight days with meal plans
                defaultBuilder: (context, date, _) {
                  if (mealPlansByDate.containsKey(date)) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.black54, height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meal Plans for Selected Date",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (selectedDay != null && mealPlansByDate[selectedDay!] != null)
              ...mealPlansByDate[selectedDay!]!.map((mealPlan) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: mealPlan,
                  ),
                );
              }),
            if (selectedDay != null && mealPlansByDate[selectedDay!] == null)
              const Text('No meal plans for this day.')
          ],
        ),
      ),
    )));
  }
}
