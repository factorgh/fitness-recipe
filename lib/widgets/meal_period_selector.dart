import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';

class MealPeriodSelector extends ConsumerStatefulWidget {
  final void Function(Map<String, List<Map<String, dynamic>>> selectedMeals)
      onSelectionChanged;
  final List<Recipe> recipes;

  const MealPeriodSelector({
    required this.onSelectionChanged,
    required this.recipes,
    super.key,
    required Null Function() onCompleteSchedule,
  });

  @override
  _MealPeriodSelectorState createState() => _MealPeriodSelectorState();
}

class _MealPeriodSelectorState extends ConsumerState<MealPeriodSelector> {
  final List<String> _mealPeriods = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
  final Map<String, List<Map<String, dynamic>>> _selectedMeals = {};

  String? _selectedMealPeriod;
  String? _selectedRecipeId;
  bool _isImageLoaded = false;

  void _onMealPeriodTap(String mealPeriod) {
    setState(() {
      _selectedMealPeriod = mealPeriod;
      _selectedRecipeId = null;
    });
  }

  void _onRecipeTap(String recipeId) async {
    setState(() {
      _selectedRecipeId = recipeId;
      Recipe? selectedRecipe =
          widget.recipes.firstWhere((recipe) => recipe.id == recipeId);
      if (_selectedMealPeriod != null) {
        if (!_selectedMeals.containsKey(_selectedMealPeriod!)) {
          _selectedMeals[_selectedMealPeriod!] = [];
        }
        if (_selectedMealPeriod == 'Snack') {
          _selectedMeals[_selectedMealPeriod!]!.add({
            'id': recipeId,
            'name': selectedRecipe.title,
          });
        } else {
          _selectedMeals[_selectedMealPeriod!] = [
            {
              'id': recipeId,
              'name': selectedRecipe.title,
            }
          ];
        }
      }
      widget.onSelectionChanged(_selectedMeals);
    });
  }

  void _removeRecipe(String mealPeriod, String recipeId) {
    setState(() {
      _selectedMeals[mealPeriod]?.removeWhere((item) => item['id'] == recipeId);
      if (_selectedMeals[mealPeriod]!.isEmpty) {
        _selectedMeals.remove(mealPeriod);
      }
      widget.onSelectionChanged(_selectedMeals);
    });
  }

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

    List<Recipe> filteredRecipes = widget.recipes
        .where((recipe) => recipe.period == _selectedMealPeriod)
        .toList();

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          Recipe recipe = filteredRecipes[index];
          bool isSelected = _selectedRecipeId == recipe.id;

          return GestureDetector(
            onTap: () => _onRecipeTap(recipe.id!),
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder background color
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) {
                                  _isImageLoaded = true;
                                  return child;
                                } else {
                                  _isImageLoaded = false;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                      value: progress.cumulativeBytesLoaded /
                                          (progress.expectedTotalBytes ?? 1),
                                    ),
                                  );
                                }
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
                    if (_isImageLoaded)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.6),
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
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.white,
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
                  label: Text('${meal['name']} '),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  deleteIcon: const Icon(Icons.cancel),
                  onDeleted: () => _removeRecipe(mealPeriod, meal['id']),
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
