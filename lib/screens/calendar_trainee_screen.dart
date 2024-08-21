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

  // Predefined list of colors to assign to meal plans
  final List<Color> availableColors = [
    Colors.red[300]!,
    Colors.blue[300]!,
    Colors.green[300]!,
    Colors.orange[300]!,
    Colors.purple[300]!,
    Colors.yellow[300]!,
    Colors.teal[300]!,
    Colors.pink[300]!,
    Colors.brown[300]!,
    Colors.cyan[300]!,
    Colors.indigo[300]!,
    Colors.lime[300]!,
    Colors.amber[300]!,
    Colors.deepOrange[300]!,
    Colors.deepPurple[300]!,
  ];

  @override
  void initState() {
    super.initState();

    // Set the selectedDay to the current date initially
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
                        // Get the first meal plan for that date and use its color
                        MealPlan mealPlan = mealPlansByDate[date]!.first;
                        Color mealPlanColor = mealPlanColors[mealPlan]!;

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: mealPlanColor,
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
