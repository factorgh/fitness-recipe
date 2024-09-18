import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/conversions/capitalize_first.dart';
import 'package:voltican_fitness/utils/socket_io_setup.dart';
import 'package:voltican_fitness/widgets/category_slider.dart';
import 'package:voltican_fitness/widgets/new_recipe_slider.dart';
import 'package:voltican_fitness/widgets/slider_trainer_landing.dart';
import 'package:badges/badges.dart' as badges;

class TrainerLandingScreen extends ConsumerStatefulWidget {
  const TrainerLandingScreen({super.key});

  @override
  ConsumerState<TrainerLandingScreen> createState() =>
      _TrainerLandingScreenState();
}

class _TrainerLandingScreenState extends ConsumerState<TrainerLandingScreen> {
  final AuthService authService = AuthService();
  List<String> _topTrainers = [];
  List<String> _trainerImages = [];
  List<String> _topTrainerIds = [];
  List<String> _topTrainersEmail = [];

  final RecipeService recipeService = RecipeService();
  List<Recipe> _recipes = [];
  late SocketService _socketService;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    authService.getMe(context: context, ref: ref);
    _fetchTopTrainers();
    _fetchTopRecipes();
    _socketService = SocketService();
    _socketService.initSocket();
    _listenForNotifications();
  }

  void _listenForNotifications() {
    final user = ref.read(userProvider);
    if (user != null) {
      _socketService.listenForNotifications(user.id, (notification) {
        _incrementNotificationCount();
      });
    }
  }

  void _incrementNotificationCount() {
    setState(() {
      _notificationCount++;
    });
  }

  void _resetNotificationCount() {
    setState(() {
      _notificationCount = 0;
    });
  }

  void _fetchTopTrainers() {
    authService.getTopTrainers(
      context: context,
      onSuccess: (trainers) {
        setState(() {
          _topTrainers =
              trainers.map((trainer) => trainer['username'] as String).toList();
          _topTrainersEmail =
              trainers.map((trainer) => trainer['email'] as String).toList();
          _topTrainerIds =
              trainers.map((trainer) => trainer['_id'] as String).toList();

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
          _recipes = recipes.map((recipe) => recipe).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final categories = [
      'Breakfast',
      'Lunch',
      'Snack',
      'Dinner',
    ];
    final categoryImages = [
      "assets/images/recipes/r6.jpg",
      "assets/images/recipes/r1.jpg",
      "assets/images/recipes/r4.jpg",
      "assets/images/recipes/r5.jpg",
    ];

    void handleCategorySelected(String category) {
      // Handle category selection
    }

    void handleRecipeSelected(Recipe recipe) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrainerMealDetailScreen(meal: recipe),
        ),
      );
    }

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  user?.imageUrl ??
                                      'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png',
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'Hello ,',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      CapitalizeFirstLetter(
                                        text: user?.username ?? '',
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Text(
                                    'Check amazing recipes and \nassign amzing meal plans..',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // right side of row
                          badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -2, end: 1),
                            showBadge: _notificationCount > 0,
                            badgeContent: Text(
                              "$_notificationCount",
                              style: const TextStyle(color: Colors.white),
                            ),
                            badgeAnimation: const badges.BadgeAnimation.slide(
                              animationDuration: Duration(milliseconds: 300),
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
                                size: 30,
                              ),
                              onPressed: () {
                                _resetNotificationCount();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsScreen()));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              // Second Row
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore All Recipes",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              // Categories
              CategorySlider(
                images: categoryImages,
                categories: categories,
                onCategorySelected: handleCategorySelected,
              ),
              // New recipe slider
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              // New recipe slider
              NewRecipeSlider(
                recipes: _recipes,
                onCategorySelected: handleRecipeSelected,
              ),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              // Trainers
              SliderTrainerLanding(
                ids: _topTrainerIds,
                emails: _topTrainersEmail,
                recipes: _topTrainers,
                images: _trainerImages,
                onTrainerSelected: handleTrainerSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
