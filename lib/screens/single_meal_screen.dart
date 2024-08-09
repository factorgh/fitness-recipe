import 'package:flutter/material.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/widgets/week_range_selector.dart';

class SingleMealPlanDetailScreen extends StatelessWidget {
  final String mealPlanName = 'Example Meal Plan Name';
  final String duration = 'Week';
  final List<String> selectedDays = ['Monday', 'Wednesday', 'Friday'];
  final Map<String, List<Map<String, dynamic>>> selectedMeals = {
    'Breakfast': [
      {'name': 'Oatmeal', 'time': '8:00 AM'},
      {'name': 'Smoothie', 'time': '8:30 AM'},
    ],
    'Lunch': [
      {'name': 'Salad', 'time': '12:00 PM'},
    ],
    'Dinner': [
      {'name': 'Pasta', 'time': '7:00 PM'},
    ],
  };

  SingleMealPlanDetailScreen({super.key});

  void _showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const Text(
                          "Update Meal Plan",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Meal Plan Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter meal plan name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          controller: TextEditingController(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: duration,
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
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Days for Meal",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        WeekRangeSelector(
                          // Pass the selected days and handle updates

                          onSelectionChanged: (newSelectedDays) {},
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Meal Periods",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MealPeriodSelector(
                          // Pass the selected meals and handle updates

                          onSelectionChanged: (newSelectedMeals) {},
                          onCompleteSchedule: () {},
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            // Handle update logic here
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Complete Update',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan Details'),
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
            Text(
              mealPlanName,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select a Duration",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              duration,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            const Text(
              "Determine Days for Meal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedDays.map((day) {
                return Chip(
                  backgroundColor: Colors.blueAccent,
                  label: Text(
                    day,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Meal Periods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedMeals.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: entry.value.map((meal) {
                        return Chip(
                          backgroundColor: Colors.blueAccent,
                          label: Text(
                            '${meal['name']} - ${meal['time']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showUpdateBottomSheet(context);
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
                'Update',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
