import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlan extends ConsumerStatefulWidget {
  const AllMealPlan({super.key});

  @override
  ConsumerState<AllMealPlan> createState() => _AllMealPlanState();
}

class _AllMealPlanState extends ConsumerState<AllMealPlan> {
  String _selectedDuration = 'Does Not Repeat';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlansProvider.notifier).fetchAllMealPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealPlansState = ref.watch(mealPlansProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Meal Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return DropdownButton<String>(
                elevation: 3,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.redAccent,
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
              );
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
                ? const Center(child: Text('No meal plans available.'))
                : mealPlansState is MealPlansLoaded
                    ? mealPlansState.mealPlans.isEmpty
                        ? const Center(child: Text('No meal plans available.'))
                        : ListView.builder(
                            itemCount: mealPlansState.mealPlans.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: CalendarItem(
                                  titleIcon: Icons.restaurant_menu,
                                  mealPlan: mealPlansState.mealPlans[index],
                                ),
                              );
                            },
                          )
                    : const Center(child: Text('Unexpected state')),
      ),
    );
  }
}
