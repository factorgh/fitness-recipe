import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/meal_plan_state.dart';
import 'package:voltican_fitness/providers/trainee_mealplans_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlanTrainee extends ConsumerStatefulWidget {
  const AllMealPlanTrainee({super.key});

  @override
  ConsumerState<AllMealPlanTrainee> createState() => _AllMealPlanTraineeState();
}

class _AllMealPlanTraineeState extends ConsumerState<AllMealPlanTrainee> {
  // DateTime? _selectedDate;
  // String _selectedDuration = 'Does Not Repeat';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final traineeId = ref.read(userProvider)!.id;
      ref
          .read(traineeMealPlansProvider.notifier)
          .fetchTraineeMealPlans(traineeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealPlansState = ref.watch(traineeMealPlansProvider);

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
              'All Meal Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: const [
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: mealPlansState is MealPlansLoading
            ? const Center(child: CircularProgressIndicator())
            : mealPlansState is MealPlansError
                ? const Center(child: Text("No meal plans available"))
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
