// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/screens/single_meal_screen_trainee.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class CalendarItemTrainee extends ConsumerWidget {
  final MealPlan mealPlan;
  final IconData titleIcon;
  final Color borderColor;
  final bool isFocused;
  final DateTime selectedDay;

  const CalendarItemTrainee({
    super.key,
    required this.selectedDay,
    required this.mealPlan,
    required this.titleIcon,
    required this.borderColor,
    required this.isFocused, // Initialize the color property
  });

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black87),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                final mealPlanId = mealPlan.id;
                final notifier = ref.read(mealPlanProvider.notifier);
                await notifier.deleteMealPlan(mealPlanId!);
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.of(context).pop();
                showSnack(context, "Meal Plan deleted successfully!");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = mealPlan.startDate != null
        ? DateFormat('MMM d, yyyy').format(mealPlan.startDate!)
        : 'Start Date Not Available';
    final endDate = mealPlan.endDate != null
        ? DateFormat('MMM d, yyyy').format(mealPlan.endDate!)
        : 'End Date Not Available';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor), // Use the provided color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: isFocused ? true : false,
            leading: Icon(titleIcon),
            title: Text(mealPlan.name),
            trailing: const Icon(Icons.arrow_drop_down),
            shape: Border.all(color: Colors.transparent),
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.schedule),
                  const SizedBox(width: 20),
                  Text(mealPlan.duration),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    const Icon(Icons.date_range),
                    const SizedBox(width: 8),
                    Text('$startDate - $endDate'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleMealPlanScreenTrainee(
                                mealPlan: mealPlan, selectedDay: selectedDay),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View Details'),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
