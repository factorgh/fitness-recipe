import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/assign_recipe_screen.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/widgets/week_range_selector.dart';

class MealCreationScreen extends StatefulWidget {
  const MealCreationScreen({super.key});

  @override
  _MealCreationScreenState createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends State<MealCreationScreen> {
  String _selectedDuration = 'Does Not Repeat';

  Map<String, List<Map<String, dynamic>>> selectedMeals = {};

  void handleMealSelectionChange(
      Map<String, List<Map<String, dynamic>>> newSelectedMeals) {
    setState(() {
      selectedMeals = newSelectedMeals;
    });
  }

  void _onSelectionChanged(List<String> selectedDays) {
    setState(() {});
  }

  void handleSelectionChange(List<String> selectedPeriods) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Meal Plan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Meal Plan Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter meal plan name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select a Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDuration,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
            const SizedBox(height: 20),
            const Text(
              "Determine Days for Meal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            WeekRangeSelector(
              // selectedDays: _selectedDays,
              onSelectionChanged: _onSelectionChanged,
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Meal Periods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            MealPeriodSelector(
              onCompleteSchedule: () {},
              // selectedPeriods: _selectedMealPeriods,
              onSelectionChanged: handleMealSelectionChange,
            ),
            const SizedBox(height: 20),
            const Text(
              "Assign recipes to meals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AssignRecipeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Complete Schedule ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
