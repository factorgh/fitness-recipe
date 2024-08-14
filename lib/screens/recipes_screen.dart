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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load all necessary data using the providers
    Future.microtask(() {
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'My Recipes'),
              Tab(text: 'Others'),
              Tab(text: 'Explore'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserRecipesTab(userRecipes),
                _buildSavedRecipesTab(savedRecipes),
                _buildAllRecipesTab(allRecipes),
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
      shrinkWrap: true,
      itemCount: userRecipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: userRecipes[index],
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

  Widget _buildAllRecipesTab(List<Recipe> allRecipes) {
    if (allRecipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: allRecipes.length,
      itemBuilder: (context, index) => RecipeItem(
        meal: allRecipes[index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
  }
}
