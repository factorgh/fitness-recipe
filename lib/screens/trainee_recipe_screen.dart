import 'package:flutter/material.dart';
import 'package:voltican_fitness/data/dummy_data.dart';
import 'package:voltican_fitness/models/meal.dart';
import 'package:voltican_fitness/screens/meal_detail_screen.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/widgets/meal_item.dart';
import 'package:voltican_fitness/widgets/recipe_item_trainer.dart';

class TraineeRecipeScreen extends StatefulWidget {
  const TraineeRecipeScreen({super.key});

  @override
  _TraineeRecipeScreenState createState() => _TraineeRecipeScreenState();
}

class _TraineeRecipeScreenState extends State<TraineeRecipeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailScreen(meal: meal),
    ));
  }

  void selectRecipe(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainerMealDetailScreen(meal: meal),
    ));
  }

  Widget buildMealList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dummyMeals.length,
      itemBuilder: (context, index) => MealItem(
        meal: dummyMeals[index],
        selectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
  }

  Widget buildRecipeList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dummyMeals.length,
      itemBuilder: (context, index) => RecipeItemTrainer(
        meal: dummyMeals[index],
        selectMeal: (meal) {
          selectRecipe(context, meal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const CreateRecipeScreen()));
                  //   },
                  //   child: const Icon(
                  //     Icons.add,
                  //     color: Colors.black,
                  //     size: 25,
                  //   ),
                  // ),
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
                buildTabContent(),
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
