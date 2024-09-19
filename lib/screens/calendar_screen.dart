import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';

import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';
import 'package:voltican_fitness/screens/meal_creation.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late MealPlanService _mealPlanService;
  List<MealPlan>? _mealPlans;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _mealPlanService = MealPlanService(); // Initialize your service
    _fetchMealPlans();
  }

  Future<void> _fetchMealPlans() async {
    try {
      final mealPlans = await _mealPlanService.fetchAllMealPlans();
      setState(() {
        _mealPlans = mealPlans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load meal plans';
        _isLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    await _fetchMealPlans(); // Refetch data when navigating back
    return true; // Allow the pop operation
  }

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;

    Widget mealPlansWidget;
    if (_isLoading) {
      mealPlansWidget = Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        child:
            const Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    } else if (_error != null) {
      mealPlansWidget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(child: Text(_error!)),
      );
    } else if (_mealPlans != null && _mealPlans!.isNotEmpty) {
      // Get the latest 3 meal plans
      final firstThreeMealPlans = _mealPlans!.take(3).toList();

      mealPlansWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const SizedBox(height: 10),
          // Display the first 3 meal plans
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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                              .then((_) =>
                                  _fetchMealPlans()); // Refetch on return
                        },
                        child: const Text(
                          'Add Meal Plan',
                          style:
                              TextStyle(fontSize: 12, color: Colors.redAccent),
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
                          .then((_) => _fetchMealPlans()); // Refetch on return
                      setState(() {
                        focusedDay = focusDay;
                        selectedDay = selectDay;
                      });
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
                    child: SingleChildScrollView(child: mealPlansWidget),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
