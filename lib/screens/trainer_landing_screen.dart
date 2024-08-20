import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/widgets/category_slider.dart';
import 'package:voltican_fitness/widgets/new_recipe_slider.dart';
import 'package:voltican_fitness/widgets/slider_trainer_landing.dart';
import 'package:badges/badges.dart' as badges;

class TrainerLandeingScreen extends ConsumerStatefulWidget {
  const TrainerLandeingScreen({super.key});

  @override
  ConsumerState<TrainerLandeingScreen> createState() =>
      _TrainerLandeingScreenState();
}

class _TrainerLandeingScreenState extends ConsumerState<TrainerLandeingScreen> {
  final AuthService authService = AuthService();
  List<String> _topTrainers = [];
  List<String> _trainerImages = [];
  List<String> _topTrainersEmail = [];

  final RecipeService recipeService = RecipeService();
  List<String> _topRecipesTitle = [];
  List<String> _recipeImages = [];
  List<String> _recipeOwnwer = [];

  @override
  void initState() {
    super.initState();
    authService.getMe(context: context, ref: ref);
    _fetchTopTrainers();
    _fetchTopRecipes();
  }

  void _fetchTopTrainers() {
    authService.getTopTrainers(
      context: context,
      onSuccess: (trainers) {
        setState(() {
          _topTrainers =
              trainers.map((trainer) => trainer['username'] as String).toList();
          _topTrainersEmail =
              trainers.map((trainer) => trainer['username'] as String).toList();

          _trainerImages = trainers
              .map((trainer) =>
                  trainer['imageUrl'] as String? ??
                  'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png')
              .toList();
        });
      },
    );
  }

  void _fetchTopRecipes() {
    recipeService.getTopRatedRecipes(
      context: context,
      onSuccess: (recipes) {
        setState(() {
          _topRecipesTitle =
              recipes.map((recipe) => recipe['title'] as String).toList();
          _recipeOwnwer = recipes
              .map((recipe) => recipe['createdBy']['username'] as String)
              .toList();
          _recipeImages =
              recipes.map((recipe) => recipe['imageUrl'] as String).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final categories = [
      'Breakfast',
      'Deserts',
      'Lunch',
      'Dinner',
      'Others',
    ];
    final categoryimages = [
      "assets/images/recipes/r6.jpg",
      "assets/images/recipes/r1.jpg",
      "assets/images/recipes/r4.jpg",
      "assets/images/recipes/r5.jpg",
      "assets/images/recipes/r2.jpg",
    ];
    final recipes = [
      'Breakfast',
      'Lunch',
      'Snack',
      'Dinner',
      'Others',
    ];

    void handleCategorySelected(String category) {
      // Handle category selection
    }

    void handleRecipSelected(String recipe) {}

    void handleTrainerSelected(String trainer) {
      // Handle trainer selection
    }

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // First Row
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            user == null
                                ? const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(
                                        'assets/images/default_profile.png'))
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(user
                                            .imageUrl ??
                                        'assets/images/default_profile.png'), // Use default image if null
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${user?.username}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const Text(
                                  'Check amazing recipes..',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        badges.Badge(
                          position:
                              badges.BadgePosition.topEnd(top: -2, end: 1),
                          showBadge: true,
                          badgeContent: const Text(
                            "0",
                            style: TextStyle(color: Colors.white),
                          ),
                          badgeAnimation: const badges.BadgeAnimation.slide(
                            animationDuration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Colors.blueGrey[900]!,
                            padding: const EdgeInsets.all(6),
                            borderRadius: BorderRadius.circular(8),
                            elevation: 3,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationsScreen()));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                              label: Text("Search recipes..")),
                        )),
                  )
                ],
              ),
            ),
            // Second Row
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Explore All Recipes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        color: Colors.red[600], fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),

            // Categories
            CategorySlider(
              images: categoryimages,
              categories: categories,
              onCategorySelected: handleCategorySelected,
            ),
            // New recipe slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        color: Colors.red[800], fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            // New recipe slider
            NewRecipeSlider(
                recipeTitles: _topRecipesTitle,
                owners: _recipeOwnwer,
                recipeImages: _recipeImages,
                recipes: recipes,
                onCategorySelected: handleRecipSelected),
            const SizedBox(
              height: 20,
            ),
            // Trainers section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Trainers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // Trainers
            SliderTrainerLanding(
              emails: _topTrainersEmail,
              recipes: _topTrainers, // Pass the names of top trainers
              images: _trainerImages, // Pass the list of trainer images
              onTrainerSelected: handleTrainerSelected,
            ),
          ],
        ),
      ),
    ));
  }
}
