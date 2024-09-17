// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/socket_io_setup.dart';
import 'package:voltican_fitness/widgets/recipe_advert_slider.dart';

import 'package:badges/badges.dart' as badges;
import 'package:voltican_fitness/widgets/slider_trainer_landing.dart';

class TraineeLandingScreen extends ConsumerStatefulWidget {
  const TraineeLandingScreen({super.key});

  @override
  _TraineeLandingScreenState createState() => _TraineeLandingScreenState();
}

class _TraineeLandingScreenState extends ConsumerState<TraineeLandingScreen> {
  final AuthService authService = AuthService();
  List<String> _topTrainers = [];
  List<String> _trainerImages = [];
  List<String> _topTrainersEmail = [];
  List<String> _topTrainerIds = [];
  late SocketService _socketService;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTopTrainers();
      _socketService = SocketService();
      _socketService.initSocket();
      _listenForNotifications();
    });
  }

  void _listenForNotifications() {
    _socketService.listenForNotifications(ref.read(userProvider)!.id,
        (notification) {
      _incrementNotificationCount();
    });
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
              trainers.map((trainer) => trainer['username'] as String).toList();
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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Stay fit with recipes for a better you',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Continue your Adventure'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleCategorySelected(String category) {
    // Handle category selection
    print('Selected category: $category');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    void handleTrainerSelected(String category) {
      // Handle category selection
      print('Selected category: $category');
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile section
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Hello, ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          user?.username ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    // right side of row
                    badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -2, end: 1),
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
                          color: Colors.red,
                          size: 25,
                        ),
                        onPressed: () {
                          _resetNotificationCount();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsScreen()));
                        },
                      ),
                    )
                  ],
                ),
              ),
              // End of first row
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Container(
                      height: 190,
                      width: 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                            image: AssetImage(
                              "assets/recipe.jpg",
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get Your Meal Today',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Easier With AR',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Food Scanner',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.orangeAccent),
                              child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.qr_code_scanner_outlined),
                                      SizedBox(width: 3),
                                      Text("Scan Now")
                                    ],
                                  )),
                            ),
                          ],
                        ))
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              // TodaysPickSlider(
              //     recipes: meals, onCategorySelected: handleCategorySelected),
              const SizedBox(
                height: 20,
              ),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SliderTrainerLanding(
                  ids: _topTrainerIds,
                  emails: _topTrainersEmail,
                  recipes: _topTrainers, // Pass the names of top trainers
                  images: _trainerImages, // Pass the list of trainer images
                  onTrainerSelected: handleTrainerSelected,
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Nutritional News",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const RecipeSlider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
