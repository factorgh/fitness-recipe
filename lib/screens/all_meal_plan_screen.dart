import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlan extends ConsumerStatefulWidget {
  const AllMealPlan({super.key});

  @override
  ConsumerState<AllMealPlan> createState() => _AllMealPlanState();
}

class _AllMealPlanState extends ConsumerState<AllMealPlan> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedDuration = 'Does Not Repeat';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(mealPlansProvider.notifier).fetchAllMealPlans();
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
    final mealPlans = ref.watch(mealPlansProvider);
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
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : mealPlans.isEmpty
                    ? const Center(child: Text('No meal plans available.'))
                    : ListView.builder(
                        itemCount: mealPlans.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CalendarItem(
                              titleIcon: Icons.restaurant_menu,
                              mealPlan: mealPlans[index],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
