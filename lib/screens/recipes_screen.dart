import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/providers/all_recipes_provider.dart';
import 'package:fit_cibus/providers/saved_recipe_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/providers/user_recipes.dart';
import 'package:fit_cibus/screens/create_recipe.screen.dart';
import 'package:fit_cibus/screens/meal_detail_screen.dart';
import 'package:fit_cibus/screens/saved_trainer_meal_details.dart';
import 'package:fit_cibus/screens/trainer_meal_details_trainee.dart';
import 'package:fit_cibus/widgets/recipe_item.dart';
import 'package:fit_cibus/widgets/recipe_item_trainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _sortOption = 'A-Z'; // Set default sort option to A-Z

  @override
  Widget build(BuildContext context) {
    final userRecipes = ref.watch(userRecipesProvider);
    final savedRecipes = ref.watch(savedRecipesProvider);
    final allRecipes = ref.watch(allRecipesProvider);

    return Container(
      width: double.infinity,
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recipes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateRecipeScreen()));
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Trainer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
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
          const SizedBox(height: 20),
          TabBar(
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
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: _buildUserRecipesTab(
                      _sortRecipes(_filterRecipes(userRecipes))),
                ),
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: _buildSavedRecipesTab(
                      _sortRecipes(_filterRecipes(savedRecipes))),
                ),
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: _buildAllRecipesTab(
                      _sortRecipes(_filterRecipes(allRecipes))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load all necessary data using the providers
    Future.microtask(() {
      _loadData();
    });
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

  Widget _buildAllRecipesTab(List<Recipe> allRecipes) {
    if (allRecipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: allRecipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: allRecipes[index],
        selectMeal: (meal) {
          selectRecipe(context, meal);
        },
      ),
    );
  }

  Widget _buildSavedRecipesTab(List<Recipe> savedRecipes) {
    if (savedRecipes.isEmpty) {
      return const Center(child: Text('No saved recipes found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: savedRecipes[index],
        selectMeal: (meal) {
          selectSavedRecipe(context, meal);
        },
      ),
    );
  }

  Widget _buildUserRecipesTab(List<Recipe> userRecipes) {
    if (userRecipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: userRecipes.length,
      itemBuilder: (context, index) => RecipeItem(
        meal: userRecipes[index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
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

  Future<void> _handleRefresh() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    final user = ref.read(userProvider);
    ref.read(userRecipesProvider.notifier).loadUserRecipes();
    ref.read(savedRecipesProvider.notifier).loadSavedRecipes(user!.id);
    ref.read(allRecipesProvider.notifier).loadAllRecipes(context);
  }

  List<Recipe> _sortRecipes(List<Recipe> recipes) {
    switch (_sortOption) {
      case 'A-Z':
        recipes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        recipes.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Most Rated':
        recipes.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
      case 'Least Rated':
        recipes.sort((a, b) => a.averageRating.compareTo(b.averageRating));
        break;
      case 'Most Recent':
        recipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Least Recent':
        recipes.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      default:
        break;
    }
    return recipes;
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
}
