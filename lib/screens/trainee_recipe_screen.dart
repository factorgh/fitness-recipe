// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/followed_user_provider.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
// import 'package:voltican_fitness/providers/saved_recipe_provider.dart';

import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/saved_trainer_meal_details.dart';
import 'package:voltican_fitness/screens/trainee_recipe_detail_screen.dart';

import 'package:voltican_fitness/widgets/recipe_item.dart';
import 'package:voltican_fitness/widgets/recipe_item_trainer.dart';

class TraineeRecipeScreen extends ConsumerStatefulWidget {
  const TraineeRecipeScreen({super.key});

  @override
  _TraineeRecipeScreenState createState() => _TraineeRecipeScreenState();
}

class _TraineeRecipeScreenState extends ConsumerState<TraineeRecipeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFollowedUsersRecipes();
    _fetchSavedRecipes();
  }

  void _fetchFollowedUsersRecipes() {
    final user = ref.read(userProvider);
    if (user == null) {
      print('Error: User is null');
      return;
    }
    final userId = user.id;
    ref.read(followedUsersRecipesProvider(userId).notifier).fetchRecipes();
  }

  void _fetchSavedRecipes() {
    final user = ref.read(userProvider);
    if (user == null) {
      print('Error: User is null');
      return;
    }
    final userId = user.id;
    ref.read(savedRecipesProvider.notifier).loadSavedRecipes(userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectMeal(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TraineeRecipeDetailScreen(meal: meal),
    ));
  }

  void selectRecipe(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SavedTrainerMealDetailScreen(meal: meal),
    ));
  }

  Widget buildMealList(List<Recipe> recipes) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: recipes.length,
      itemBuilder: (context, index) => RecipeItem(
        meal: recipes[index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
  }

  Widget buildRecipeList(List<Recipe> recipes) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: recipes.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: recipes[index],
        selectMeal: (meal) {
          selectRecipe(context, meal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.read(userProvider)?.id;
    final followedRecipes = ref.watch(followedUsersRecipesProvider(userId!));
    final savedRecipes = ref.watch(savedRecipesProvider);

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
                "All Recipes",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
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
                          'Trainee',
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
              Tab(text: 'Explore'),
              Tab(text: 'Saved Recipe'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                followedRecipes.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Error: $error'),
                  ),
                  data: (recipes) => recipes.isEmpty
                      ? const Center(
                          child: Text('No followed recipes found.'),
                        )
                      : buildMealList(recipes),
                ),
                savedRecipes.isEmpty
                    ? const Center(
                        child: Text('No saved recipes found.'),
                      )
                    : buildRecipeList(savedRecipes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          hintText: "Search by recipe name",
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterIcon() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list, color: Colors.grey[500]),
      onSelected: (String value) {
        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        return <String>[
          'A-Z',
          'Z-A',
          'Most Recent',
          'Least Recent',
          'Most Rated',
          'Least Rated',
        ].map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
