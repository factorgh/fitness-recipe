import 'package:badges/badges.dart' as badges;
import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/notify_screen.dart';
import 'package:fit_cibus/screens/trainer_meal_details_trainee.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:fit_cibus/utils/conversions/capitalize_first.dart';
import 'package:fit_cibus/utils/socket_io_setup.dart';
import 'package:fit_cibus/widgets/category_slider.dart';
import 'package:fit_cibus/widgets/new_recipe_slider.dart';
import 'package:fit_cibus/widgets/slider_trainer_landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              user?.imageUrl ??
                                  'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png',
                            ),
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

                        // Row end
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Hello, ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              CapitalizeFirstLetter(
                                text: user?.username ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          const Text(
                            'Check amazing recipes and assign amzing meal plans...',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
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

  void _incrementNotificationCount() {
    setState(() {
      _notificationCount++;
    });
  }

  void _listenForNotifications() {
    final user = ref.read(userProvider);
    if (user != null) {
      _socketService.listenForNotifications(user.id, (notification) {
        _incrementNotificationCount();
      });
    }
  }

  void _resetNotificationCount() {
    setState(() {
      _notificationCount = 0;
    });
  }
}
