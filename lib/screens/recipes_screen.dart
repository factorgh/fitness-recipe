import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
import 'package:voltican_fitness/providers/user_recipes.dart';
import 'package:voltican_fitness/screens/create_recipe.screen.dart';
import 'package:voltican_fitness/screens/meal_detail_screen.dart';
import 'package:voltican_fitness/screens/saved_trainer_meal_details.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';

import 'package:voltican_fitness/widgets/recipe_item.dart';
import 'package:voltican_fitness/widgets/recipe_item_trainer.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _sortOption = 'Default'; // Default sort option

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load all necessary data using the providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userRecipesProvider.notifier).loadUserRecipes();
      ref
          .read(savedRecipesProvider.notifier)
          .loadSavedRecipes('userId'); // Replace 'userId' with actual ID
      ref
          .read(allRecipesProvider.notifier)
          .loadAllRecipes(context); // Load all recipes here
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectMeal(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailScreen(meal: meal),
    ));
  }

  void selectRecipe(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainerMealDetailScreen(meal: meal),
    ));
  }

  void selectSavedRecipe(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SavedTrainerMealDetailScreen(meal: meal),
    ));
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _updateSortOption(String option) {
    setState(() {
      _sortOption = option;
    });
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    if (_searchQuery.isEmpty) {
      return recipes;
    }
    return recipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Recipe> _sortRecipes(List<Recipe> recipes) {
    switch (_sortOption) {
      case 'A-Z':
        recipes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        recipes.sort((a, b) => b.title.compareTo(a.title));
        break;

      // case 'Most Rated':
      //   recipes.sort((a, b) => b.ratings.compareTo(a.ratings));
      //   break;
      // case 'Least Rated':
      //   recipes.sort((a, b) => a.ratings.compareTo(b.ratings));
      //   break;
      case 'Most Recent':
        recipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Least Recent':
        recipes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      default:
        // Default sorting, if needed
        break;
    }
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    final userRecipes = ref.watch(userRecipesProvider);
    final savedRecipes = ref.watch(savedRecipesProvider);
    final allRecipes = ref.watch(allRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateRecipeScreen()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: 'My Recipes'),
            Tab(text: 'Saved'),
            Tab(text: 'Explore'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search Recipes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: _updateSortOption,
                  itemBuilder: (BuildContext context) {
                    return [
                      'A-Z',
                      'Z-A',
                      'Most Rated',
                      'Least Rated',
                      'Most Recent',
                      'Least Recent',
                    ].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserRecipesTab(_sortRecipes(_filterRecipes(userRecipes))),
                _buildSavedRecipesTab(
                    _sortRecipes(_filterRecipes(savedRecipes))),
                _buildAllRecipesTab(_sortRecipes(_filterRecipes(allRecipes))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRecipesTab(List<Recipe> userRecipes) {
    if (userRecipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return ListView.builder(
      itemCount: userRecipes.length,
      itemBuilder: (context, index) => RecipeItem(
        meal: userRecipes[index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
  }

  Widget _buildSavedRecipesTab(List<Recipe> savedRecipes) {
    if (savedRecipes.isEmpty) {
      return const Center(child: Text('No saved recipes found'));
    }

    return ListView.builder(
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: savedRecipes[index],
        selectMeal: (meal) {
          selectSavedRecipe(context, meal);
        },
      ),
    );
  }

  Widget _buildAllRecipesTab(List<Recipe> allRecipes) {
    if (allRecipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return ListView.builder(
      itemCount: allRecipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: allRecipes[index],
        selectMeal: (meal) {
          selectRecipe(context, meal);
        },
      ),
    );
  }
}
