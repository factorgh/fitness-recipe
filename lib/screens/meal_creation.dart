// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/widgets/week_range_selector.dart';

class MealCreationScreen extends ConsumerStatefulWidget {
  final DateTime selectedDay;
  const MealCreationScreen({super.key, required this.selectedDay});

  @override
  _MealCreationScreenState createState() => _MealCreationScreenState();
}

class _MealCreationScreenState extends ConsumerState<MealCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDuration = 'Does Not Repeat';
  DateTime? _startDate;
  DateTime? _endDate;
  List<User> _allTrainees = [];
  List<User> _searchResults = [];
  final List<User> _selectedTrainees = [];
  bool _isLoading = false;
  List<String> _weekDays = [];
  final List<RecipeAllocation> _selectedRecipeAllocations = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

  Map<String, List<Map<String, dynamic>>> selectedMeals = {};
  List<Recipe> myRecipes = [];

  final RecipeService recipeService = RecipeService();
  final TrainerService trainerService = TrainerService();

  // This will store the selected recipe IDs flattened into a list of strings

  // Callback function to handle selection changes
  void _handleRecipeSelectionChanged(
      List<RecipeAllocation> selectedAllocations) {
    setState(() {
      _selectedRecipeAllocations.clear();
      _selectedRecipeAllocations.addAll(selectedAllocations);
    });
  }

  void _onSelectionChanged(List<String> selectedDays) {
    setState(() {
      _weekDays = selectedDays;
    });
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
          // If the start date is updated, adjust the end date based on the current duration
          if (_selectedDuration != 'Custom') {
            _endDate = _calculateEndDate(_startDate!, _selectedDuration);
          }
        } else {
          _endDate = pickedDate;
          // Set the duration to 'Custom' if the end date is manually edited
          _selectedDuration = 'Custom';
        }
      });
    }
  }

  DateTime _calculateEndDate(DateTime startDate, String duration) {
    Duration period;
    switch (duration) {
      case 'Week':
        period = const Duration(days: 7);
        break;
      case 'Month':
        period = const Duration(days: 30);
        break;
      case 'Quarter':
        period = const Duration(days: 90);
        break;
      case 'Half-Year':
        period = const Duration(days: 180);
        break;
      case 'Year':
        period = const Duration(days: 365);
        break;
      default:
        return startDate; // Default to startDate if duration is not recognized
    }
    return startDate.add(period);
  }

  @override
  void initState() {
    _startDate = widget.selectedDay;

    fetchAllUserRecipes();
    getTraineesFollowingTrainer();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mealPlanNameController.dispose();
    super.dispose();
  }

  Future<void> fetchAllUserRecipes() async {
    try {
      myRecipes = await recipeService.fetchRecipesByUser();
      setState(() {});
    } catch (e) {
      showSnack(context, 'Failed to load user recipes');
    }
  }

  Future<void> getTraineesFollowingTrainer() async {
    try {
      final user = ref.read(userProvider);
      if (user != null) {
        _allTrainees =
            await trainerService.getTraineesFollowingTrainer(user.id);
        setState(() {});
      } else {
        showSnack(context, 'User not found');
      }
    } catch (e) {
      showSnack(context, 'Failed to load trainees');
    }
  }

  void _searchTrainees(String query) {
    setState(() {
      _searchResults = _allTrainees.where((trainee) {
        final fullName = trainee.fullName.toLowerCase();
        final username = trainee.username.toLowerCase();
        final searchQuery = query.toLowerCase();

        return fullName.contains(searchQuery) || username.contains(searchQuery);
      }).toList();
    });
  }

  void _addTrainee(User trainee) {
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

  void _removeTrainee(User trainee) {
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
        startDate: _startDate,
        endDate: _endDate,
        days: _weekDays,
        periods: [],
        recipeAllocations: _selectedRecipeAllocations,
        trainees: _selectedTrainees.map((trainee) => trainee.id).toList(),
        createdBy: user!.id,
      );

      try {
        setState(() {
          _isLoading = true;
        });
        await ref.read(mealPlanProvider.notifier).createMealPlan(mealPlan);
        showSnack(context, 'Meal plan created successfully');
        setState(() {
          _isLoading = false;
          Navigator.pop(context);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create meal plan: $e')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Meal Plan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Add Trainees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search trainees...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _searchTrainees,
              ),
              const SizedBox(height: 10),
              if (_searchResults.isNotEmpty)
                Column(
                  children: _searchResults.map((trainee) {
                    return ListTile(
                      title: Text(trainee.fullName),
                      subtitle: Text(trainee.username),
                      trailing: ElevatedButton(
                        onPressed: () => _addTrainee(trainee),
                        child: const Text('Add'),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 10),
              const Text(
                "Selected Trainees",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_selectedTrainees.isNotEmpty)
                Column(
                  children: _selectedTrainees.map((trainee) {
                    return ListTile(
                      title: Text(trainee.fullName),
                      subtitle: Text(trainee.username),
                      trailing: ElevatedButton(
                        onPressed: () => _removeTrainee(trainee),
                        child: const Text('Remove'),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
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
                  labelText: 'Duration',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: <String>[
                  'Does Not Repeat',
                  'Week',
                  'Month',
                  'Quarter',
                  'Half-Year',
                  'Year',
                  'Custom',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDuration = newValue!;
                    if (_selectedDuration != 'Custom') {
                      if (_startDate != null) {
                        _endDate =
                            _calculateEndDate(_startDate!, _selectedDuration);
                      }
                    } else {
                      _endDate =
                          null; // Clear end date if duration is set to 'Custom'
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Start Date',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _startDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_startDate!)
                                  : 'Select Start Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('End Date', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _endDate != null
                                  ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                  : 'Select End Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Meal Periods",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              WeekRangeSelector(
                // Provide your selected days here
                onSelectionChanged: _onSelectionChanged,
              ),
              const SizedBox(height: 20),
              MealPeriodSelector(
                recipes: myRecipes, // Pass actual recipes here

                onSelectionChanged: _handleRecipeSelectionChanged,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: _completeSchedule,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Create',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
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
