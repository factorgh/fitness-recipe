import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';
import 'package:voltican_fitness/screens/assign_recipe_screen.dart';
import 'package:voltican_fitness/screens/recipe_grid_screen.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/calendar_item.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/week_range_selector.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  String _selectedDuration = 'Does Not Repeat';
  Map<String, List<Map<String, dynamic>>> selectedMeals = {};

  void handleSelectionChange(
      Map<String, List<Map<String, dynamic>>> newSelectedMeals) {
    setState(() {
      selectedMeals = newSelectedMeals;
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, scrollController) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30)),
                  )),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter meal plan name",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter meal plan name',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Select a duration",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                value: _selectedDuration,
                                items: [
                                  'Does Not Repeat',
                                  'Week',
                                  'Month',
                                  'Quarter',
                                  'Half-Year',
                                  'Year',
                                  'Custom'
                                ]
                                    .map((duration) => DropdownMenuItem<String>(
                                          value: duration,
                                          child: Text(duration),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDuration = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Determine days for meal  ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            WeekRangeSelector(
                                onSelectionChanged: _onSelectionChanged),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Select meal periods  ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MealPeriodSelector(
                              onSelectionChanged: handleSelectionChange,
                              onCompleteSchedule: () {},
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AssignRecipeScreen()));
                              },
                              child: const Text('Complete Schedule'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSelectionChanged(List<String> selectedDays) {
    setState(() {});
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
                      color: Colors.black45),
                ),
                const Spacer(),
                OutlinedButton(
                    onPressed: () {
                      _showBottomSheet(context);
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
                        "29 July, 2024",
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
                  const CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Poached Eggs meal plan",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Baked Salmon with strawberries",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CalendarItem(
                    titleIcon: Icons.restaurant_menu,
                    mealPlan: "Baked Salmon with strawberries",
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
