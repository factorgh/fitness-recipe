// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';

import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';
import 'package:voltican_fitness/widgets/week_range_selector.dart';

class MealUpdateScreen extends ConsumerStatefulWidget {
  final MealPlan mealPlan;

  const MealUpdateScreen({super.key, required this.mealPlan});

  @override
  _MealUpdateScreenState createState() => _MealUpdateScreenState();
}

class _MealUpdateScreenState extends ConsumerState<MealUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDuration = 'Does Not Repeat';
  DateTime? _startDate;
  DateTime? _endDate;
  List<User> _allTrainees = [];
  List<User> _searchResults = [];
  final List<User> _selectedTrainees = [];
  bool _isLoading = false;
  List<String> _weekDays = [];
  final List<Meal> _selectedRecipeAllocations = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

  List<Recipe> myRecipes = [];

  final RecipeService recipeService = RecipeService();
  final TrainerService trainerService = TrainerService();

  @override
  void initState() {
    super.initState();

    // Prepopulate form with passed MealPlan object
    fetchInitialData();

    fetchAllUserRecipes();
    getTraineesFollowingTrainer();
  }

  Future<void> fetchInitialData() async {
    await getTraineesFollowingTrainer();
    _prepopulateForm(widget.mealPlan);
    fetchAllUserRecipes();
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

  void _prepopulateForm(MealPlan mealPlan) {
    _mealPlanNameController.text = mealPlan.name;
    _selectedDuration = mealPlan.duration;
    _startDate = mealPlan.startDate;
    _endDate = mealPlan.endDate;

    _selectedRecipeAllocations.addAll(mealPlan.meals);
    print(
        '----------------Prepopulated-----------------------------$_weekDays');

    List<User> selectedTrainees = [];

    for (String id in mealPlan.trainees) {
      // Find the corresponding user
      List<User> matchedUsers =
          _allTrainees.where((trainee) => trainee.id == id).toList();

      // Only add if a matching user is found
      if (matchedUsers.isNotEmpty) {
        selectedTrainees.add(matchedUsers.first);
      }
    }

    if (selectedTrainees.isEmpty) {
      print('Warning: No matching trainees found');
    }

    _selectedTrainees.addAll(selectedTrainees);
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
      final mealUpdate = MealPlan(
        id: widget.mealPlan.id, // Use the ID from the passed MealPlan object
        name: _mealPlanNameController.text,
        duration: _selectedDuration,
        startDate: _startDate,
        endDate: _endDate,
        meals: _selectedRecipeAllocations,
        trainees: _selectedTrainees.map((trainee) => trainee.id).toList(),
        createdBy: user!.id,
      );

      try {
        setState(() {
          _isLoading = true;
        });
        await ref
            .read(mealPlansProvider.notifier)
            .updateMealPlan(widget.mealPlan.id!, mealUpdate);
        NativeAlerts()
            .showSuccessAlert(context, 'Meal plan updated successfully');
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllMealPlan()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        NativeAlerts()
            .showErrorAlert(context, 'Failed to update meal plan: $e');
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

  void _selectDate(BuildContext context, bool isStartDate) async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Meal Plan',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _mealPlanNameController,
                        decoration: const InputDecoration(
                          labelText: 'Meal Plan Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a meal plan name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedDuration,
                        items: const [
                          DropdownMenuItem(
                              value: 'Does Not Repeat',
                              child: Text('Does Not Repeat')),
                          DropdownMenuItem(value: 'Week', child: Text('Week')),
                          DropdownMenuItem(
                              value: 'Month', child: Text('Month')),
                          DropdownMenuItem(
                              value: 'Quarter', child: Text('Quarter')),
                          DropdownMenuItem(
                              value: 'Half-Year', child: Text('Half-Year')),
                          DropdownMenuItem(value: 'Year', child: Text('Year')),
                          DropdownMenuItem(
                              value: 'Custom', child: Text('Custom')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDuration = value!;
                            if (_selectedDuration != 'Custom') {
                              _endDate = _calculateEndDate(
                                  _startDate ?? DateTime.now(),
                                  _selectedDuration);
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectDate(context, true),
                              child: Text(_startDate == null
                                  ? 'Select Start Date'
                                  : DateFormat('dd MMMM, yyyy')
                                      .format(_startDate!)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectDate(context, false),
                              child: Text(_endDate == null
                                  ? 'Select End Date'
                                  : DateFormat('dd MMMM, yyyy')
                                      .format(_endDate!)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      MealPeriodSelector(
                        onRecurrenceChanged: (reccurreneDta) {},
                        onSelectionChanged: (allocations) {
                          setState(() {
                            _selectedRecipeAllocations.clear();
                            _selectedRecipeAllocations.addAll(allocations);
                          });
                        },
                        recipes:
                            myRecipes, // Ensure `myRecipes` is a list of `Recipe` objects
                      ),
                      const SizedBox(height: 16),
                      WeekRangeSelector(
                        initialSelectedDays:
                            _weekDays, // Prepopulate with selected days
                        onSelectionChanged: (selectedDays) {
                          setState(() {
                            _weekDays = selectedDays;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Trainees',
                        ),
                        onChanged: _searchTrainees,
                      ),
                      const SizedBox(height: 16),
                      if (_searchResults.isNotEmpty)
                        ..._searchResults.map(
                          (trainee) => ListTile(
                            title: Text(trainee.fullName),
                            subtitle: Text(trainee.username),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _addTrainee(trainee),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (_selectedTrainees.isNotEmpty)
                        ..._selectedTrainees.map(
                          (trainee) => ListTile(
                            title: Text(trainee.fullName),
                            subtitle: Text(trainee.username),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _removeTrainee(trainee),
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Set to 0 for a perfect rectangle
                            ),
                          ),
                          onPressed: _completeSchedule,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Save Meal Plan',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
