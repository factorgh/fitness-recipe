// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/providers/trainee_mealplans_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/widgets/calendar_item_trainee.dart';

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
  Map<MealPlan, Color> mealPlanColors = {};
  bool isFocused = false;

  // Predefined list of colors to assign to meal plans
  final List<Color> availableColors = [
    const Color(0xFFB71C1C), // Deep Red
    const Color(0xFF0D47A1), // Deep Blue
    const Color(0xFF1B5E20), // Deep Green
    const Color(0xFFEF6C00), // Deep Orange
    const Color(0xFF4A148C), // Deep Purple
    const Color(0xFFF57F00), // Deep Yellow
    const Color(0xFF004D40), // Deep Teal
    const Color(0xFFC51162), // Deep Pink
    const Color(0xFF3E2723), // Deep Brown
    const Color(0xFF006064), // Deep Cyan
    const Color(0xFF283593), // Deep Indigo
    const Color(0xFF9E9D24), // Deep Lime
    const Color(0xFFFF6F00), // Deep Amber
    const Color(0xFFBF360C), // Deep Deep Orange
    const Color(0xFF4A148C), // Deep Deep Purple
  ];

  @override
  void initState() {
    super.initState();

    focusedDay = DateTime.now();
    selectedDay = DateTime.now();

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

      // Populate mealPlansByDate map and assign colors to meal plans
      mealPlansByDate = {};
      mealPlanColors = {};
      int colorIndex = 0;

      for (var mealPlan in mealPlans) {
        if (mealPlan.startDate != null && mealPlan.endDate != null) {
          // Assign a unique color to the meal plan
          mealPlanColors[mealPlan] =
              availableColors[colorIndex % availableColors.length];
          colorIndex++;

          DateTime currentDate = mealPlan.startDate!;
          while (!currentDate.isAfter(mealPlan.endDate!)) {
            if (!mealPlansByDate.containsKey(currentDate)) {
              mealPlansByDate[currentDate] = [];
            }
            mealPlansByDate[currentDate]!.add(mealPlan);
            currentDate = currentDate.add(const Duration(days: 1));
          }
        } else {
          print('Meal plan with null start or end date found: ${mealPlan.id}');
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          centerTitle: true,
          title: const Text(
            'Meal Plan Calendar',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: SafeArea(
            child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2001, 7, 20),
                  focusedDay: focusedDay,
                  lastDay: DateTime.utc(2040, 3, 20),
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  onDaySelected: (DateTime focusDay, DateTime selectDay) {
                    setState(() {
                      focusedDay = focusDay;
                      selectedDay = selectDay;
                      isFocused = true;
                    });
                  },
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      final bool hasMealPlans =
                          mealPlansByDate.containsKey(date);
                      final Color dotColor = hasMealPlans
                          ? mealPlanColors[mealPlansByDate[date]!.first]!
                          : Colors.transparent;

                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: date == DateTime.now()
                              ? Colors.blueAccent.withOpacity(
                                  0.3) // Background color for the current day
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: date == focusedDay
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // Only show the dot if the day has meal plans and is not the selected day
                            if (hasMealPlans && date != selectedDay)
                              Positioned(
                                top: 8,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: dotColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    selectedBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: date == selectedDay
                              ? Colors.blueAccent.withOpacity(
                                  0.2) // Background color for the selected day
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: date == focusedDay
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // No dot shown on the selected day
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(color: Colors.black54, height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Meal Plans",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (selectedDay != null &&
                    mealPlansByDate[selectedDay!] != null)
                  ...mealPlansByDate[selectedDay!]!.map((mealPlan) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CalendarItemTrainee(
                        isFocused: isFocused,
                        titleIcon: Icons.restaurant_menu,
                        mealPlan: mealPlan,
                        borderColor: mealPlanColors[mealPlan]!,
                      ),
                    );
                  }),
                if (selectedDay != null &&
                    mealPlansByDate[selectedDay!] == null)
                  const Text('No meal plans for this day.')
              ],
            ),
          ),
        )));
  }
}
