// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  const MealCreationScreen({super.key});

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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

  Map<String, List<Map<String, dynamic>>> selectedMeals = {};
  List<Recipe> myRecipes = [];

  final RecipeService recipeService = RecipeService();
  final TrainerService trainerService = TrainerService();

  // This will store the selected recipe IDs flattened into a list of strings
  List<String> _selectedRecipeIds = [];

  // Callback function to handle selection changes
  void _handleRecipeSelectionChanged(
      Map<String, List<Map<String, dynamic>>> selectedMeals) {
    // Flatten the selected recipe IDs into a list of strings
    List<String> recipeIds = [];

    selectedMeals.forEach((mealPeriod, meals) {
      recipeIds.addAll(meals.map((meal) => meal['id'] as String));
    });

    setState(() {
      _selectedRecipeIds = recipeIds;
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
  void initState() {
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
        startDate: _selectedDuration == 'Custom' ? _startDate : null,
        endDate: _selectedDuration == 'Custom' ? _endDate : null,
        days: [], // Populate with selected days
        periods: [], // Populate with selected periods
        recipes: _selectedRecipeIds, // Flattened recipe IDs
        trainees: _selectedTrainees
            .map((trainee) => trainee.id) // Map User objects to IDs
            .toList(),
        createdBy: user!.id, // Replace with actual user ID
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
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _startDate != null
                              ? _startDate!.toString()
                              : 'Select Start Date',
                          style: const TextStyle(fontSize: 16),
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
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _endDate != null
                              ? _endDate!.toString()
                              : 'Select End Date',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                onCompleteSchedule: () {},
                onSelectionChanged: _handleRecipeSelectionChanged,
              ),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: _completeSchedule,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Complete Schedule'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
