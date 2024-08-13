// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/utils/show_snackbar.dart';

import 'package:voltican_fitness/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/widgets/week_range_selector.dart';

class MealCreationScreen extends ConsumerStatefulWidget {
  const MealCreationScreen({super.key});

  @override
  _MealCreationScreenState createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends ConsumerState<MealCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDuration = 'Does Not Repeat';
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _allTrainees = []; // Will be populated with real data
  List<String> _searchResults = [];
  final List<String> _selectedTrainees = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

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

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    if (isStartDate && _startDate != null) {
      initialDate = _startDate!;
    } else if (!isStartDate && _endDate != null) {
      initialDate = _endDate!;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null &&
        pickedDate != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mealPlanNameController.dispose();
    super.dispose();
  }

  void _searchTrainees(String query) {
    setState(() {
      _searchResults = _allTrainees
          .where(
              (trainee) => trainee.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addTrainee(String trainee) {
    if (_selectedTrainees.contains(trainee)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Duplicate Entry'),
          content: const Text('This trainee has already been added.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _selectedTrainees.add(trainee);
        _searchController.clear();
        _searchResults.clear();
      });
    }
  }

  void _removeTrainee(String trainee) {
    setState(() {
      _selectedTrainees.remove(trainee);
    });
  }

  Future<void> _completeSchedule() async {
    final user = ref.read(userProvider);
    if (_formKey.currentState!.validate()) {
      final mealPlan = MealPlan(
        name: _mealPlanNameController.text,
        duration: _selectedDuration,
        startDate: _selectedDuration == 'Custom' ? _startDate : null,
        endDate: _selectedDuration == 'Custom' ? _endDate : null,
        days: [], // Populate with selected days
        periods: [], // Populate with selected periods
        recipes: [], // Populate with selected recipes
        trainees: _selectedTrainees
            .map((trainee) => trainee)
            .toList(), // Map trainee names to IDs as needed
        createdBy: user!.id, // Replace with actual user ID
      );

      try {
        await ref.read(mealPlanProvider.notifier).createMealPlan(mealPlan);
        showSnack(context, 'Meal plan created successfully');
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create meal plan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Meal Plan Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mealPlanNameController,
                decoration: InputDecoration(
                  labelText: 'Enter meal plan name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meal plan name';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_selectedDuration == 'Custom')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Date', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black38),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startDate != null
                                  ? _startDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0]
                                  : 'Select start date',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('End Date', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black38),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _endDate != null
                                  ? _endDate!.toLocal().toString().split(' ')[0]
                                  : 'Select end date',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.calendar_today, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text(
                "Determine Days for Meal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WeekRangeSelector(
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
                onSelectionChanged: handleMealSelectionChange,
              ),
              const SizedBox(height: 20),
              const Text(
                "Assign recipes to trainees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Trainees',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () =>
                            _searchTrainees(_searchController.text),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: _searchResults
                        .map((trainee) => ListTile(
                              title: Text(trainee),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _addTrainee(trainee),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Selected Trainees:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Column(
                    children: _selectedTrainees
                        .map((trainee) => ListTile(
                              title: Text(trainee),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _removeTrainee(trainee),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _completeSchedule,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  'Complete Schedule',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
