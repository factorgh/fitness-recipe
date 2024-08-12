// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/commons/constants/loading_spinner.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/recipe_provider.dart';
import 'package:voltican_fitness/screens/create_recipe.screen.dart';
import 'package:voltican_fitness/screens/meal_detail_screen.dart';
import 'package:voltican_fitness/screens/saved_trainer_meal_details.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
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
  List<Recipe>? userRecipes;
  List<Recipe>? myRecipes;

  final RecipeService recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchAllRecipes();
    fetchAllUserRecipes();
  }

  Future<void> fetchAllRecipes() async {
    print('Fetching recipes...');
    try {
      userRecipes = await recipeService.fetchAllRecipes(context);
      print('Recipes fetched: ${userRecipes?.length}');
      setState(() {});
    } catch (e) {
      print('Error fetching recipes: $e');
      showSnack(context, 'Failed to load recipes');
    }
  }

  Future<void> fetchAllUserRecipes() async {
    print('Fetching recipes...');
    try {
      myRecipes = await recipeService.fetchRecipesByUser();
      print('Recipes fetched: ${myRecipes?.length}');
      setState(() {});
    } catch (e) {
      print('Error fetching recipes: $e');
      showSnack(context, 'Failed to load  user recipes');
    }
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

  Widget buildMealList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userRecipes!.length,
      itemBuilder: (context, index) => RecipeItem(
        meal: userRecipes![index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
  }

  Widget buildRecipeList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userRecipes?.length ?? 0,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: userRecipes![index], // Ensure this matches the type expected
        selectMeal: (meal) {
          selectRecipe(context, meal);
        },
      ),
    );
  }

  Widget buildSavedRecipeList(recipes) {
    return recipes.isEmpty
        ? const Center(child: Text('No saved recipes found'))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: recipes?.length ?? 0,
            itemBuilder: (context, index) => RecipeItemTrainer(
              meal: recipes![index], // Ensure this matches the type expected
              selectMeal: (meal) {
                selectSavedRecipe(context, meal);
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
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
                userRecipes == null ? const Loader() : buildTabContent(),
                buildSavedRecipeTabContent(savedRecipes),
                buildRecipeTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: buildSearchBar()),
              buildFilterIcon(),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: buildMealList()),
        ],
      ),
    );
  }

  Widget buildRecipeTabContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: buildSearchBar()),
              buildFilterIcon(),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: buildRecipeList()),
        ],
      ),
    );
  }

  Widget buildSavedRecipeTabContent(recipes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: buildSearchBar()),
              buildFilterIcon(),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: buildSavedRecipeList(recipes)),
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
