// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/screens/create_recipe.screen.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/hive/hive_class.dart';

import 'package:voltican_fitness/widgets/recurrence_sheet.dart';
import 'package:intl/intl.dart';

class MealPeriodSelector extends ConsumerStatefulWidget {
  final void Function(List<Meal>) onSelectionChanged;
  final List<Recipe> recipes;
  final void Function(Recurrence) onRecurrenceChanged;
  final void Function()? saveToDraft;
  final Recurrence? chosenRecurrence;
  final GlobalKey? key4;
  final GlobalKey? key5;
  final GlobalKey? key6;

  final List<Meal>? defaultMeals;
  final DateTime? selectedDay;
  final DateTime startDate;
  final DateTime endDate;

  const MealPeriodSelector({
    required this.onSelectionChanged,
    required this.onRecurrenceChanged,
    required this.recipes,
    required this.startDate,
    required this.endDate,
    this.saveToDraft,
    this.defaultMeals,
    this.selectedDay,
    this.chosenRecurrence,
    this.key4,
    this.key5,
    this.key6,
    super.key,
  });

  @override
  _MealPeriodSelectorState createState() => _MealPeriodSelectorState();
}

class _MealPeriodSelectorState extends ConsumerState<MealPeriodSelector>
    with SingleTickerProviderStateMixin {
  final List<String> _mealPeriods = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
  final Map<String, List<Meal>> _selectedMeals = {};

  Recurrence? recurrence;

  RecipeService recipeService = RecipeService();
  Future<List<String>> fetchRecipeTitles(List<String> recipeIds) async {
    final List<String> titles = [];

    try {
      for (String recipeId in recipeIds) {
        final recipe = await recipeService.getRecipeById(recipeId);
        if (recipe != null) {
          titles.add(recipe.title);
        }
      }
    } catch (e) {
      print('Error fetching recipe titles: $e');
      // Handle error as needed
    }

    return titles;
  }

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mealPeriods.length, vsync: this);

    _initializeSelectedMeals();
  }

  @override
  void didUpdateWidget(covariant MealPeriodSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.defaultMeals != oldWidget.defaultMeals ||
        widget.selectedDay != oldWidget.selectedDay) {
      // Check if the data actually changed before updating
      if (widget.defaultMeals?.toString() !=
              oldWidget.defaultMeals?.toString() ||
          widget.selectedDay != oldWidget.selectedDay) {
        _initializeSelectedMeals();
      }
    }
  }

//  Default meal initialization
  void _initializeSelectedMeals() {
    _selectedMeals.clear();
    if (widget.defaultMeals != null && widget.defaultMeals!.isNotEmpty) {
      for (var meal in widget.defaultMeals!) {
        if (_selectedMeals[meal.mealType] == null) {
          _selectedMeals[meal.mealType] = [];
        }
        _selectedMeals[meal.mealType]!.add(meal);
      }
    }
    // Notify parent widget even if no meals are selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged(_convertToRecipeAllocations());
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _onRecipeTap(String recipeId, String mealPeriod) async {
    TimeOfDay startTime;
    TimeOfDay endTime;

    switch (mealPeriod) {
      case 'Breakfast':
        startTime = const TimeOfDay(hour: 0, minute: 0);
        endTime = const TimeOfDay(hour: 11, minute: 59);
        break;
      case 'Lunch':
        startTime = const TimeOfDay(hour: 12, minute: 0);
        endTime = const TimeOfDay(hour: 17, minute: 59);
        break;
      case 'Dinner':
        startTime = const TimeOfDay(hour: 18, minute: 0);
        endTime = const TimeOfDay(hour: 23, minute: 59);
        break;
      case 'Snack':
      default:
        startTime = const TimeOfDay(hour: 0, minute: 0);
        endTime = const TimeOfDay(hour: 23, minute: 59);
        break;
    }

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
      helpText: 'Select Time for $mealPeriod',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) {
      return;
    }

    // Check if the selected time is within the allowed range
    if (!_isTimeWithinRange(selectedTime, startTime, endTime)) {
      // Show an error if the selected time is outside the valid range
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Invalid Time for $mealPeriod',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Text(
                'Please select a time between ${startTime.format(context)} and ${endTime.format(context)} for $mealPeriod.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    DateTime allocatedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      selectedTime.hour,
      selectedTime.minute,
    );

    Recipe? selectedRecipe = widget.recipes.firstWhere(
      (recipe) => recipe.id == recipeId,
    );

    // Format the selected time as a string
    String formattedTime = DateFormat('hh:mm a').format(allocatedTime);

    setState(() {
      // Create a new meal allocation
      Meal allocation = Meal(
        date: DateTime.now(),
        mealType: mealPeriod,
        recipes: [selectedRecipe.id!],
        timeOfDay: formattedTime,
        recurrence: recurrence,
      );

      // Initialize _selectedMeals if it doesn't exist for the current meal period
      if (_selectedMeals[mealPeriod] == null) {
        _selectedMeals[mealPeriod] = [];
      }

      // Add the new meal allocation based on the meal period
      if (mealPeriod == 'Snack') {
        // Allow multiple snack meals
        _selectedMeals[mealPeriod]!.add(allocation);
      } else {
        // Replace the current meal for breakfast, lunch, or dinner
        _selectedMeals[mealPeriod] = [allocation];
      }

      // Notify parent widget about the updated selections
      widget.onSelectionChanged(_convertToRecipeAllocations());
    });
  }

  bool _isTimeWithinRange(
      TimeOfDay selectedTime, TimeOfDay startTime, TimeOfDay endTime) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    final startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    return selectedDateTime.isAfter(startDateTime) &&
        selectedDateTime.isBefore(endDateTime);
  }

  void _removeRecipe(String mealPeriod, String recipeId) async {
    final hiveService = HiveService();

    // Remove the meal from Hive for the selected date and meal period
    print('-------------------SelectedDate and meal period--------------');
    print(widget.selectedDay);
    print(mealPeriod);
    if (widget.selectedDay != null) {
      await hiveService.deleteMealForDate(widget.selectedDay!, mealPeriod);
    } else {
      // Handle the case where either widget.selectedDay or mealPeriod is null
      print('Error: Either widget.selectedDay or mealPeriod is null.');
      // Optionally, show an error message or provide a fallback
    }

    setState(() {
      // Remove the recipe ID from the list of recipe IDs in the UI (_selectedMeals)
      _selectedMeals[mealPeriod]?.removeWhere((allocation) {
        return allocation.recipes != null &&
            allocation.recipes!.contains(recipeId);
      });

      // If the meal period has no more meals, remove the entire period
      if (_selectedMeals[mealPeriod]?.isEmpty ?? false) {
        _selectedMeals.remove(mealPeriod);
      }

      // Notify the parent widget of the change
      widget.onSelectionChanged(_convertToRecipeAllocations());
    });
  }

  List<Meal> _convertToRecipeAllocations() {
    List<Meal> allocations = [];
    _selectedMeals.forEach((mealPeriod, meals) {
      allocations.addAll(meals);
    });
    return allocations;
  }

  void _handleRecurrenceSelection() async {
    final Map<String, dynamic>? recurrenceData =
        await showRecurrenceBottomSheet(
            context, widget.startDate, widget.endDate);

    if (recurrenceData != null) {
      // Process the recurrence data
      print('Selected Recurrence Data: $recurrenceData');

      // Extracting recurrence option and custom days
      final String recurrencyOption = recurrenceData['option'] ?? 'None';
      final List<int> customDays =
          List<int>.from(recurrenceData['customDays'] ?? []);

      // Properly convert customDates to DateTime from string if needed
      final List<DateTime> customDates =
          (recurrenceData['customDates'] as List<dynamic>?)
                  ?.map((date) => DateTime.parse(date as String))
                  .toList() ??
              [];

      setState(() {
        recurrence = Recurrence(
          option: recurrencyOption,
          date: DateTime.now(),
          customDays: customDays,
          customDates: customDates,
        );
      });

      // Trigger the recurrence change callback
      widget.onRecurrenceChanged(recurrence!);
    }
  }

  Widget _buildRecipeSelector(String mealPeriod) {
    List<Recipe> filteredRecipes =
        widget.recipes.where((recipe) => recipe.period == mealPeriod).toList();

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: filteredRecipes.isEmpty
          ? Center(
              child: RichText(
              text: TextSpan(
                text: 'No meal period available.',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: ' Click here to create a meal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          Colors.blue, // Set color to indicate it's clickable
                      decoration: TextDecoration
                          .underline, // Optional: underline to indicate a link
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreateRecipeScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = filteredRecipes[index];
                bool isSelected = _selectedMeals[mealPeriod]?.any(
                        (allocation) =>
                            allocation.recipes!.contains(recipe.id)) ??
                    false;

                return GestureDetector(
                  onTap: () => _onRecipeTap(recipe.id!, mealPeriod),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      border: isSelected
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: recipe.imageUrl.isNotEmpty
                                ? Image.network(
                                    recipe.imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.redAccent,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes
                                                      as int)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              child: Text(
                                recipe.title.length > 8
                                    ? '${recipe.title.substring(0, 8)}...'
                                    : recipe.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSelectedMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedMeals.entries.map((entry) {
        String mealPeriod = entry.key;
        List<Meal> allocations = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      mealPeriod,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
            Wrap(
              spacing: 8,
              children: allocations.map((allocation) {
                return FutureBuilder<List<String>>(
                  future: fetchRecipeTitles(allocation.recipes!),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // Create display text
                      String displayText = snapshot.data!.join(', ');
                      displayText += ' @ ${allocation.timeOfDay}';

                      // Set the max length to show 2/3 of the characters
                      int maxLength = (displayText.length * 2 / 3).round();
                      String truncatedText = displayText.length > maxLength
                          ? '${displayText.substring(0, maxLength)}...'
                          : displayText;

                      return Row(
                        children: [
                          Chip(
                            label: Text(
                              truncatedText,
                              maxLines: 1, // Keep text in one line
                              overflow: TextOverflow
                                  .ellipsis, // Show ellipsis when text is too long
                            ),
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            deleteIcon: const Icon(Icons.cancel),
                            onDeleted: () => _removeRecipe(
                                mealPeriod, allocation.recipes!.first),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh,
                                color: Colors.redAccent),
                            onPressed: () => _handleRecurrenceSelection(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.chosenRecurrence != null
                                  ? _showRecurrSaveDialog()
                                  : _showSaveDialog();
                            },
                            child: const Tooltip(
                              message: 'Save', // Tooltip message
                              child: Icon(
                                Icons.save,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('No data');
                    }
                  },
                );
              }).toList(),
            )
          ],
        );
      }).toList(),
    );
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text('Save meal for the specific date and time?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                widget.saveToDraft?.call(); // Perform the save action
              },
            ),
          ],
        );
      },
    );
  }

  void _showRecurrSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text('Save meal for selected recurring period?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();

                widget.saveToDraft?.call(); // Perform the save action
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        "-----------------------------recurrences-----------------------------$recurrence");

    // Check if there are any meals selected by the user or from the defaultMeals
    bool hasMeals = _selectedMeals.isNotEmpty ||
        (widget.defaultMeals != null && widget.defaultMeals!.isNotEmpty);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _mealPeriods.map((mealPeriod) {
            return Tab(text: mealPeriod);
          }).toList(),
        ),
        SizedBox(
          height: 220,
          child: TabBarView(
            controller: _tabController,
            children: _mealPeriods.map((mealPeriod) {
              return _buildRecipeSelector(mealPeriod);
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Conditionally show _buildSelectedMeals only if there are meals to display
        if (hasMeals) _buildSelectedMeals(),
      ],
    );
  }
}
