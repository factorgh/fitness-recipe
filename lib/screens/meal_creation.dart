// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/meal_plan_preview_screen.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/hive/hive_class.dart';
import 'package:voltican_fitness/utils/hive/hive_meal.dart';
import 'package:voltican_fitness/utils/hive/hive_recurrence.dart';
import 'package:voltican_fitness/utils/hive/mealplan.dart' as hive_mealplan;
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/meal_period_selector.dart';

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
  final bool _isLoading = false;
  final List<DateTime> _highlightedDates = [];
  List<Meal> startMeals = [];
  List<Meal> _draftMeals = [];

  List<Meal> newMeals = [];

  final List<Meal> _selectedRecipeAllocations = [];
  Recurrence? chosenRecurrence;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mealPlanNameController = TextEditingController();

  Map<String, List<Map<String, dynamic>>> selectedMeals = {};
  List<Recipe> myRecipes = [];
  final MealPlanService mealPlanService = MealPlanService();
  final RecipeService recipeService = RecipeService();
  final TrainerService trainerService = TrainerService();
  DateTime? newDay;

  MealPlan? mealPlanDraft;

  // Callback function to handle selection changes
  void _handleRecipeSelectionChanged(List<Meal> selectedAllocations) {
    print("Recurrence");

    for (Meal meal in selectedAllocations) {
      print("------------Meal Allocation------------");
      print("Meal Type: ${meal.mealType}");
      print("Date: ${meal.date}");
      print("Allocated Time: ${meal.timeOfDay}");
      print("Recipes:");
      for (Recipe recipe in meal.recipes!) {
        print("Recipe ID: ${recipe.id}");
        print("Recipe Title: ${recipe.title}");
      }
    }

    setState(() {
      _selectedRecipeAllocations.clear();
      _selectedRecipeAllocations.addAll(selectedAllocations);
    });

    print(
      '------------------allocations------------------$_selectedRecipeAllocations',
    );
  }

  void handleSelectionChange(List<String> selectedPeriods) {
    setState(() {});
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
    super.initState();
    _startDate = widget.selectedDay;
    _updateHighlightedDates();
    fetchAllUserRecipes();
    getTraineesFollowingTrainer();
    // getDraftMealPlan();
    // Initialize HiveService outside of initState
    _initializeHiveService();
  }

  Future<void> _initializeHiveService() async {
    final hiveService = HiveService();
    await hiveService.init();

    setState(() {});
  }

  Future<void> getDraftMealPlan() async {
    try {
      final draftPlan = await mealPlanService.getMealPlanDraft();
      print('------------------draft plan----------------');
      print(draftPlan);

      setState(() {
        mealPlanDraft = draftPlan;

        // Ensure mealPlanDraft is not null before accessing fields
        if (mealPlanDraft != null) {
          _mealPlanNameController.text = mealPlanDraft!.name;

          _selectedDuration = mealPlanDraft!.duration;
          // Populate selected meals safely

          print(
              '-----------------------------meals --------------------------');
          print(mealPlanDraft!.meals);
          _draftMeals = mealPlanDraft!.meals;
          _selectedRecipeAllocations.clear();
          _selectedRecipeAllocations.addAll(mealPlanDraft!.meals);

          // Set the start and end dates safely
          _startDate = mealPlanDraft!.startDate;
          _endDate = mealPlanDraft!.endDate;

          // Update highlighted dates for the calendar
          _updateHighlightedDates();

          // Clear and populate selected trainees if not null
          _selectedTrainees.clear();
          for (var traineeId in mealPlanDraft!.trainees) {
            final trainee = _allTrainees.firstWhere(
              (user) => user.id == traineeId,
            );
            _selectedTrainees.add(trainee);
          }
        }
      });
    } catch (e) {
      print('Error fetching draft meal plan: $e');
      // Optionally, show error in the UI
    }

    // Refresh ui for state persistency
    setState(() {});
  }

// Get meals by date from the draft
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

  @override
  void dispose() {
    _searchController.dispose();
    _mealPlanNameController.dispose();
    super.dispose();
  }

// Highlighted dates logic
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

  // SelectDate logic

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
        _updateHighlightedDates();
      });
    }
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

  void createPlan() {
    _completeSchedule();
  }

  bool _isWithinRange(DateTime day) {
    if (_startDate != null && _endDate != null) {
      return day.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          day.isBefore(_endDate!.add(const Duration(days: 1)));
    }
    return true;
  }

// Start of complete schedule
  Future<void> _completeSchedule() async {
    final user = ref.read(userProvider);
    final List<Meal> meals = [];

    if (user == null) {
      print('---------user is null----');
    }

    for (Meal meal in _selectedRecipeAllocations) {
      print("------------Meal Allocation------------");
      for (Recipe recipe in meal.recipes!) {
        print("Recipe ID: ${recipe.id}");
        print("Recipe Title: ${recipe.title}");

        if (newDay == null) {
          print('----------------------------newDay is null------------------');
        }

        meals.add(Meal(
          mealType: meal.mealType,
          date: newDay!,
          timeOfDay: meal.timeOfDay,
          recipes: [recipe],
          recurrence: chosenRecurrence,
        ));
      }
    }

    print(
        "\n================================meals================================$meals");

    final mealPlan = MealPlan(
        name: _mealPlanNameController.text,
        duration: _selectedDuration,
        startDate: _startDate,
        endDate: _endDate,
        meals: meals,
        trainees: _selectedTrainees.map((trainee) => trainee.id).toList(),
        createdBy: user!.id,
        isDraft: false);
    print('---------------------mealplan-------------$mealPlan');
    ref.read(mealPlanProvider.notifier).createMealPlan(mealPlan, context);
    Navigator.of(context).pop();
  }

// Handle recurrence here
  void handleRecurrence(Map<String, dynamic> recurrenceData) {
    print(
        '---------------------recurrence before preview------------$recurrenceData');

    setState(() {
      // Convert the Map<String, dynamic> to a Recurrence object using fromJson
      chosenRecurrence = Recurrence.fromJson(recurrenceData);
    });
  }

  // Hive implementations
  void onSaveMeal() async {
    final List<Meal> meals = [];
    for (Meal meal in _selectedRecipeAllocations) {
      print("------------Meal Allocation------------");
      for (Recipe recipe in meal.recipes!) {
        print("Recipe ID: ${recipe.id}");
        print("Recipe Title: ${recipe.title}");

        meals.add(Meal(
          mealType: meal.mealType,
          date: newDay!,
          timeOfDay: meal.timeOfDay,
          recipes: [recipe],
          recurrence: chosenRecurrence,
        ));
      }
    }
  }

  HiveRecurrence convertToHiveRecurrence(Recurrence recurrence) {
    return HiveRecurrence(
        option: recurrence.option,
        date: recurrence.date,
        customDates: recurrence.customDates,
        exceptions: recurrence.exceptions,
        customDays: recurrence.customDays);
  }

//Convert to hive meals
  List<HiveMeal> convertMealsToHiveMeals(List<Meal> meals) {
    return meals.map((meal) {
      return HiveMeal(
        // Check for null and provide default values or handle null cases
        mealType: meal.mealType, // Provide a default value if necessary
        recipes: meal.recipes ?? [], // Provide an empty list if recipes is null
        isDraft: true,
        timeOfDay: meal.timeOfDay, // Provide a default value if necessary
        date: meal.date, // Provide a default value if necessary
        recurrence: meal.recurrence != null
            ? convertToHiveRecurrence(meal.recurrence!)
            : null, // Handle null recurrence case

        // etc.
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Meal Plan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // Fetching a MealPlan
                final hiveService = HiveService();
                final fetchedMealPlan = await hiveService.getDraftMealPlan();
                print('--------------all-------$fetchedMealPlan');

                // check hive box state
                final hiveState = hiveService.isMealPlanBoxEmpty();
                print('----------------hiveState----------------$hiveState');

                final List<Meal> meals = [];

                // Create stor instance

                for (Meal meal in _selectedRecipeAllocations) {
                  print("------------Meal Allocation------------");
                  for (Recipe recipe in meal.recipes!) {
                    print("Recipe ID: ${recipe.id}");
                    print("Recipe Title: ${recipe.title}");

                    meals.add(Meal(
                      mealType: meal.mealType,
                      date: newDay!,
                      timeOfDay: meal.timeOfDay,
                      recipes: [recipe],
                      recurrence: chosenRecurrence,
                    ));
                  }
                }
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () async {
                final hiveService = HiveService();

                // Creating or updating a MealPlan
                final mealPlan = hive_mealplan.MealPlan(
                  id: '2',
                  name: 'Weekly Plan',
                  duration: 'Week',
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(days: 7)),
                  datesArray: [DateTime.now()],
                  meals: [],
                  trainees: ['trainee1', 'trainee2'],
                  createdBy: 'user123',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                print('------------------------$mealPlan');
                await hiveService.saveDraftMealPlan(mealPlan);
              },
              icon: const Icon(Icons.view_week))
        ],
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
                      _endDate = null;
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
                              color:
                                  Colors.red, // Highlight selected date in red
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                                child: Text(
                                    date.day.toString())), // Display day number
                          );
                        },
                      ),
                      selectedDayPredicate: (day) => isSameDay(day, newDay),
                      onDaySelected:
                          (DateTime selectDay, DateTime focusDay) async {
                        // Check if the selected day is within the range

                        // final meals =
                        //     await mealPlanService.getMealByDate(selectDay);
                        if (_isWithinRange(selectDay)) {
                          // Fetch meals for the selected day from the meal draft
                          if (_draftMeals.isNotEmpty) {
                            getMealsFromDraftByDate(selectDay);
                            // Refresh the ui
                            setState(() {});
                          } else if (_draftMeals.isEmpty) {
                            setState(() {
                              startMeals = [];
                            });
                          }
                          // Debugging information
                          print('-------------- trainer -------------');
                          print('Selected Day: $selectDay');

                          print('Start Meals: $startMeals');

                          // Update the state with the new day and fetched meals
                          setState(() {
                            newDay = selectDay;
                          });
                        }
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      availableGestures: AvailableGestures.all,
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              newDay != null
                  ? MealPeriodSelector(
                      recipes: myRecipes,
                      onRecurrenceChanged: handleRecurrence,
                      onSelectionChanged: _handleRecipeSelectionChanged,
                      defaultMeals: startMeals.isNotEmpty ? startMeals : [],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  // Save meal to hive with the date
                  final hiveService = HiveService();
                  final meals =
                      convertMealsToHiveMeals(_selectedRecipeAllocations);
                  // Save the meals to hive with the date

                  print(
                      '-------------------------Save to hive meal draft box ----------------');

                  await hiveService.saveRecurringMealsInDraft(
                      meals, _startDate!, _endDate!);
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20),
                        ),
                      ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  // createPlan();

                  ///Delay for sometime then after show bottom  sheet with meal plan preview
                  Future.delayed(
                    const Duration(milliseconds: 3000),
                  );

                  //  Fectch meal plan from db

                  final mealPlan = MealPlan(
                    name: _mealPlanNameController.text,
                    duration: _selectedDuration,
                    startDate: _startDate,
                    endDate: _endDate,
                    meals: _selectedRecipeAllocations,
                    trainees:
                        _selectedTrainees.map((trainee) => trainee.id).toList(),
                    createdBy: ref.read(userProvider)!.id,
                  );
                  showMealPlanPreviewBottomSheet(context, createPlan, mealPlan);
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Preview',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20),
                        ),
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
