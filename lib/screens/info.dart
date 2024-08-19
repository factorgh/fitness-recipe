import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlanTrainee extends ConsumerStatefulWidget {
  const AllMealPlanTrainee({super.key});

  @override
  ConsumerState<AllMealPlanTrainee> createState() => _AllMealPlanTraineeState();
}

class _AllMealPlanTraineeState extends ConsumerState<AllMealPlanTrainee> {
  DateTime? _selectedDate;
  String _selectedDuration = 'Does Not Repeat';

  @override
  void initState() {
    super.initState();

    // Defer the call to after widget build
    Future.microtask(() async {
      final traineeId = ref.read(userProvider)?.id;
      print(traineeId); // Using ref.read here
      await ref
          .read(mealPlansProvider.notifier)
          .fetchMealPlansByTrainee(traineeId!);
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealPlansState = ref.watch(mealPlansProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Meal Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          DropdownButton<String>(
            elevation: 3,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500),
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
                ref
                    .read(mealPlansProvider.notifier)
                    .filterByDuration(_selectedDuration);
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: mealPlansState is MealPlansLoading
            ? const Center(child: CircularProgressIndicator())
            : mealPlansState is MealPlansError
                ? Center(child: Text((mealPlansState).error))
                : mealPlansState is MealPlansLoaded
                    ? mealPlansState.mealPlans.isEmpty
                        ? const Center(child: Text('No meal plans available.'))
                        : ListView.builder(
                            itemCount: (mealPlansState).mealPlans.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: CalendarItem(
                                  titleIcon: Icons.restaurant_menu,
                                  mealPlan: (mealPlansState).mealPlans[index],
                                ),
                              );
                            },
                          )
                    : const Center(child: Text('Unexpected state')),
      ),
    );
  }
}