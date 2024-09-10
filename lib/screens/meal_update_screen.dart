// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/all_meal_plan_screen.dart';

import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/conversions/hive_conversions.dart';
import 'package:voltican_fitness/utils/hive/hive_class.dart';
import 'package:voltican_fitness/utils/hive/hive_meal.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';

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
  final List<DateTime> _highlightedDates = [];
  bool _isLoading = false;
  Recurrence? chosenRecurrence;

  final List<Meal> _selectedRecipeAllocations = [];
  List<Meal> _draftMeals = [];
  List<Meal> startMeals = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

  List<Recipe> myRecipes = [];
  DateTime? newDay;

  final RecipeService recipeService = RecipeService();
  final TrainerService trainerService = TrainerService();
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    _updateHighlightedDates();
    _initializeHiveService();

    fetchInitialData();

// Save meal plans to meal to allow user to update
    _saveMealsToDraftOnInitialization();

    fetchAllUserRecipes();
    getTraineesFollowingTrainer();
  }

  void _saveMealsToDraftOnInitialization() async {
    print(
        '---------------------Meals from meal plan on update screen------------------');
    print(widget.mealPlan.meals);
    // Iterate over the meal plan's meals
    final hiveMeals = widget.mealPlan.meals.map((meal) {
      final hiveRecurrence = meal.recurrence != null
          ? convertToHiveRecurrence(meal.recurrence!)
          : null; // Handle null case

      // Create the HiveMeal object with the converted recurrence
      return HiveMeal(
        mealType: meal.mealType,
        timeOfDay: meal.timeOfDay,
        isDraft: meal.isDraft!,
        recipes: meal.recipes!,
        recurrence: hiveRecurrence,
        date: meal.date,
      );
    }).toList();

    // Convert the list of meals to HiveMeals and save them
    await _hiveService.saveMealListToDraftBox(hiveMeals);
  }

  void _updateHighlightedDates() {
    if (_startDate != null && _endDate != null) {
      _highlightedDates.clear();
      DateTime date = _startDate!;
      while (date.isBefore(_endDate!.add(const Duration(days: 1)))) {
        _highlightedDates.add(date);
        date = date.add(const Duration(days: 1));
      }
    }
  }

  Future<void> _initializeHiveService() async {
    final hiveService = HiveService();
    await hiveService.init();

    setState(() {});
  }

  bool _isWithinRange(DateTime day) {
    if (_startDate != null && _endDate != null) {
      return day.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          day.isBefore(_endDate!.add(const Duration(days: 1)));
    }
    return true;
  }

  void getMealsFromDraftByDate(DateTime date) async {
    try {
      final meals = _draftMeals.filter((meal) => meal.date == date).toList();
      print(
          '------------------------------meal from draft that matches the date-------------------');
      print(meals);
      setState(() {
        // Update meals safely
        startMeals = meals;
      });
    } catch (e) {
      print('Error fetching meals by date: $e');
    }
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

  void _moveToNextDay() {
    if (newDay != null) {
      setState(() {
        newDay = newDay!.add(const Duration(days: 1));
      });
    } else {
      print('newDay is null');
    }
  }

  void _handleRecipeSelectionChanged(List<Meal> selectedAllocations) {
    print("Recurrence");

    for (Meal meal in selectedAllocations) {
      print("------------Meal Allocation------------");
      print("Meal Type: ${meal.mealType}");
      print("Date: ${meal.date}");
      print("Allocated Time: ${meal.timeOfDay}");
      print('Alloacted recurrences: ${meal.recurrence}');
      print("Recipes:");
    }

    setState(() {
      _selectedRecipeAllocations.clear();
      _selectedRecipeAllocations.addAll(selectedAllocations);
    });

    print(
      '------------------allocations------------------$_selectedRecipeAllocations',
    );
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
        id: widget.mealPlan.id,
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

  void handleRecurrence(Recurrence recurrenceData) {
    print(
        '---------------------recurrence before preview------------$recurrenceData');

    setState(() {
      //
      chosenRecurrence = recurrenceData;
    });
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Trainees',
                        ),
                        onChanged: _searchTrainees,
                      ),
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
                      const SizedBox(height: 20),
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
                      _endDate != null
                          ? TableCalendar(
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              focusedDay: newDay ?? DateTime.now(),
                              rangeStartDay: _startDate,
                              rangeEndDay: _endDate,
                              rowHeight: 43,
                              calendarBuilders: CalendarBuilders(
                                selectedBuilder: (context, date, _) {
                                  return Container(
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .red, // Highlight selected date in red
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Center(
                                        child: Text(date.day
                                            .toString())), // Display day number
                                  );
                                },
                              ),
                              selectedDayPredicate: (day) =>
                                  isSameDay(day, newDay),
                              onDaySelected: (DateTime selectDay,
                                  DateTime focusDay) async {
                                final hiveService = HiveService();

                                if (_isWithinRange(selectDay)) {
                                  // Fetch meals for the selected day from the meal draft
                                  final meals = await hiveService
                                      .fetchMealsForDate(selectDay);

                                  print(
                                      '----------------------mealsByDate--------------------');
                                  print(meals);

                                  // Convert Hive meals to normal meals if there are any, or assign an empty list of type Meal
                                  final selectMeals = meals.isNotEmpty
                                      ? convertHiveMealsToMeals(meals)
                                      : <Meal>[];

                                  // Update the state with the selected day and fetched meals
                                  setState(() {
                                    startMeals = selectMeals;
                                    newDay = selectDay;
                                  });

                                  setState(() {});
                                  // Debugging information
                                  print('Selected Day: $selectDay');
                                  print('Start Meals: $startMeals');
                                }
                              },
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              availableGestures: AvailableGestures.all,
                            )
                          : const SizedBox(),
                      MealPeriodSelector(
                        defaultMeals: startMeals.isNotEmpty ? startMeals : [],
                        startDate: _startDate!,
                        endDate: _endDate!,
                        onRecurrenceChanged: handleRecurrence,
                        onSelectionChanged: (allocations) {
                          setState(() {
                            _selectedRecipeAllocations.clear();
                            _selectedRecipeAllocations.addAll(allocations);
                          });
                        },
                        recipes: myRecipes,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              // Create an instance of HiveService
                              final hiveService = HiveService();

                              // Convert selected recipe allocations to HiveMeals
                              final meals = convertMealsToHiveMeals(
                                _selectedRecipeAllocations,
                                chosenRecurrence,
                              );

                              // Save each meal to Hive for the specified date
                              for (final meal in meals) {
                                print(
                                    '---------------------Save to Hive meal draft box ----------------$meal');
                                await hiveService.updateMealForDate(
                                    newDay!, meal, context);
                              }

                              // Move to the next day regardless of recurrence
                              _moveToNextDay(); // Always move to the next day
                            },
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Continue to Next Day',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
