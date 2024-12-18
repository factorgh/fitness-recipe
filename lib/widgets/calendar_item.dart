// ignore_for_file: use_build_context_synchronously

import 'package:fit_cibus/models/mealplan.dart';
import 'package:fit_cibus/providers/calendar_mealplan_prov.dart';
import 'package:fit_cibus/providers/meal_plan_provider.dart';
import 'package:fit_cibus/providers/trainer_provider.dart';
import 'package:fit_cibus/screens/single_meal_screen.dart';
import 'package:fit_cibus/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarItem extends ConsumerWidget {
  final MealPlan mealPlan;
  final IconData titleIcon;

  const CalendarItem({
    super.key,
    required this.mealPlan,
    required this.titleIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final traineeDetailsAsyncValue =
        ref.watch(traineeDetailsProvider(mealPlan.trainees));

    final startDate = mealPlan.startDate != null
        ? DateFormat('MMM d, yyyy').format(mealPlan.startDate!)
        : 'Start Date Not Available';
    final endDate = mealPlan.endDate != null
        ? DateFormat('MMM d, yyyy').format(mealPlan.endDate!)
        : 'End Date Not Available';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
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
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text('Trainees'),
                ],
              ),
              const SizedBox(height: 5),
              traineeDetailsAsyncValue.when(
                data: (trainees) {
                  // Limit to first 3 trainees and show "and X others"
                  final displayedTrainees = trainees.take(3).toList();
                  final remainingCount = trainees.length - 3;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ...displayedTrainees.map((trainee) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundImage: trainee.imageUrl != null
                                    ? NetworkImage(trainee.imageUrl!)
                                    : const AssetImage(
                                            'assets/images/default_profile.png')
                                        as ImageProvider,
                              ),
                            )),
                        if (remainingCount > 0)
                          Text('and $remainingCount others'),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.redAccent,
                )),
                error: (error, stack) => const Text('Error loading trainees'),
              ),
              const SizedBox(height: 5),
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
                            builder: (context) =>
                                SingleMealPlanDetailScreen(mealPlan: mealPlan),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View Details'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black87),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this item?',
                ),
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
                Navigator.of(context).pop();
                Future.delayed(Duration.zero, () {
                  ref.read(calmealPlanProvider.notifier).fetchMealPlans();
                  ref.read(mealPlansProvider.notifier).fetchAllMealPlans();
                });

                showSnack(context, "Meal Plan deleted successfully!");
              },
            ),
          ],
        );
      },
    );
  }
}
