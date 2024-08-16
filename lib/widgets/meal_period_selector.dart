// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';

class MealPeriodSelector extends ConsumerStatefulWidget {
  final void Function(List<RecipeAllocation>) onSelectionChanged;

  final List<Recipe> recipes;

  const MealPeriodSelector({
    required this.onSelectionChanged,
    required this.recipes,
    super.key,
  });

  @override
  _MealPeriodSelectorState createState() => _MealPeriodSelectorState();
}

class _MealPeriodSelectorState extends ConsumerState<MealPeriodSelector>
    with SingleTickerProviderStateMixin {
  final List<String> _mealPeriods = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
  final Map<String, List<RecipeAllocation>> _selectedMeals = {};

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _mealPeriods.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onRecipeTap(String recipeId, String mealPeriod) async {
    // Determine the valid time range for the selected meal period
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
      return; // User canceled the time picker
    }

    if (!_isTimeWithinRange(selectedTime, startTime, endTime)) {
      // Show alert dialog if time is outside the allowed range
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Time for $mealPeriod'),
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
      return; // Do not proceed if time is invalid
    }

    DateTime allocatedTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      RecipeAllocation allocation = RecipeAllocation(
        recipeId: recipeId,
        allocatedTime: allocatedTime,
      );

      if (!_selectedMeals.containsKey(mealPeriod)) {
        _selectedMeals[mealPeriod] = [];
      }

      _selectedMeals[mealPeriod]!.add(allocation);
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

  void _removeRecipe(String mealPeriod, String recipeId) {
    setState(() {
      _selectedMeals[mealPeriod]
          ?.removeWhere((allocation) => allocation.recipeId == recipeId);
      if (_selectedMeals[mealPeriod]?.isEmpty ?? false) {
        _selectedMeals.remove(mealPeriod);
      }
      widget.onSelectionChanged(_convertToRecipeAllocations());
    });
  }

  List<RecipeAllocation> _convertToRecipeAllocations() {
    List<RecipeAllocation> allocations = [];
    _selectedMeals.forEach((mealPeriod, allocationsList) {
      allocations.addAll(allocationsList);
    });
    return allocations;
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          Recipe recipe = filteredRecipes[index];
          bool isSelected = _selectedMeals[mealPeriod]
                  ?.any((allocation) => allocation.recipeId == recipe.id) ??
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes
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
        List<RecipeAllocation> allocations = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealPeriod,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: allocations.map((allocation) {
                Recipe? recipe = widget.recipes
                    .firstWhere((recipe) => recipe.id == allocation.recipeId);
                String displayText = recipe.title;
                displayText +=
                    ' @ ${allocation.allocatedTime.hour}:${allocation.allocatedTime.minute.toString().padLeft(2, '0')}';

                return Chip(
                  label: Text(displayText),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  deleteIcon: const Icon(Icons.cancel),
                  onDeleted: () =>
                      _removeRecipe(mealPeriod, allocation.recipeId),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          height: 220, // Adjust height as needed
          child: TabBarView(
            controller: _tabController,
            children: _mealPeriods.map((mealPeriod) {
              return _buildRecipeSelector(mealPeriod);
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        _buildSelectedMeals(),
      ],
    );
  }
}
