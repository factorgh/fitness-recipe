import 'package:flutter/material.dart';

class MealPeriodSelector extends StatefulWidget {
  final void Function(Map<String, List<Map<String, dynamic>>> selectedMeals)
      onSelectionChanged;

  const MealPeriodSelector(
      {required this.onSelectionChanged,
      super.key,
      required Null Function() onCompleteSchedule});

  @override
  _MealPeriodSelectorState createState() => _MealPeriodSelectorState();
}

class _MealPeriodSelectorState extends State<MealPeriodSelector> {
  final List<String> _mealPeriods = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
  final Map<String, List<Map<String, dynamic>>> _selectedMeals = {};
  final List<String> _recipes = [
    'Recipe 1',
    'Recipe 2',
    'Recipe 3',
    'Recipe 4'
  ]; // Example recipes
  String? _selectedMealPeriod;
  String? _selectedRecipe;

  void _onMealPeriodTap(String mealPeriod) {
    setState(() {
      _selectedMealPeriod = mealPeriod;
      _selectedRecipe = null;
    });
  }

  void _onRecipeTap(String recipe) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedRecipe = recipe;
        if (_selectedMealPeriod != null) {
          if (!_selectedMeals.containsKey(_selectedMealPeriod!)) {
            _selectedMeals[_selectedMealPeriod!] = [];
          }
          if (_selectedMealPeriod == 'Snack') {
            _selectedMeals[_selectedMealPeriod!]!.add({
              'recipe': recipe,
              'time': selectedTime.format(context),
            });
          } else {
            _selectedMeals[_selectedMealPeriod!] = [
              {
                'recipe': recipe,
                'time': selectedTime.format(context),
              }
            ];
          }
        }
        widget.onSelectionChanged(_selectedMeals);
      });
    }
  }

  void _removeRecipe(String mealPeriod, String recipe) {
    setState(() {
      _selectedMeals[mealPeriod]
          ?.removeWhere((item) => item['recipe'] == recipe);
      if (_selectedMeals[mealPeriod]!.isEmpty) {
        _selectedMeals.remove(mealPeriod);
      }
      widget.onSelectionChanged(_selectedMeals);
    });
  }

  // void _changeTime(String mealPeriod, String recipe) async {
  //   TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );

  //   if (selectedTime != null) {
  //     setState(() {
  //       for (var meal in _selectedMeals[mealPeriod]!) {
  //         if (meal['recipe'] == recipe) {
  //           meal['time'] = selectedTime.format(context);
  //         }
  //       }
  //       widget.onSelectionChanged(_selectedMeals);
  //     });
  //   }
  // }

  Widget _buildMealPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mealPeriods.map((mealPeriod) {
        bool isSelected = _selectedMealPeriod == mealPeriod;
        return GestureDetector(
          onTap: () => _onMealPeriodTap(mealPeriod),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? null : Border.all(color: Colors.grey),
            ),
            child: Text(
              mealPeriod,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecipeSelector() {
    if (_selectedMealPeriod == null) {
      return Container();
    }
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          String recipe = _recipes[index];
          bool isSelected = _selectedRecipe == recipe;
          return GestureDetector(
            onTap: () => _onRecipeTap(recipe),
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image:
                      AssetImage('assets/recipe.jpg'), // Placeholder image path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  recipe,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    backgroundColor: isSelected
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                  ),
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
        List<Map<String, dynamic>> meals = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealPeriod,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: meals.map((meal) {
                return Chip(
                  label: Text('${meal['recipe']} (${meal['time']})'),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  deleteIcon: const Icon(Icons.cancel),
                  onDeleted: () => _removeRecipe(mealPeriod, meal['recipe']),
                  // onSelected: () => _changeTime(mealPeriod, meal['recipe']),
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
        _buildMealPeriodSelector(),
        const SizedBox(height: 20),
        _buildRecipeSelector(),
        const SizedBox(height: 20),
        _buildSelectedMeals(),
      ],
    );
  }
}
