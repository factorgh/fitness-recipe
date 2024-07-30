import 'package:flutter/material.dart';
import 'package:voltican_fitness/widgets/recipe_advert_slider.dart';
import 'package:voltican_fitness/widgets/todays_pick.dart';
import 'package:voltican_fitness/widgets/trainers_slider.dart';

class TraineeLandingScreen extends StatefulWidget {
  const TraineeLandingScreen({super.key});

  @override
  _TraineeLandingScreenState createState() => _TraineeLandingScreenState();
}

class _TraineeLandingScreenState extends State<TraineeLandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet(context);
    });
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

  void handleTrainerSelected(String category) {
    // Handle category selection
    print('Selected category: $category');
  }

  @override
  Widget build(BuildContext context) {
    final meals = [
      'Breakfast',
      'Deserts',
      'Lunch',
      'Dinner',
      'Others',
    ];
    final trainers = [
      'Albert M.',
      'Ernest A.',
      'Lucis M.',
      'Mills A.',
      'William A.',
    ];
    final images = [
      "assets/images/pf.jpg",
      "assets/images/pf2.jpg",
      "assets/images/pf3.jpg",
      "assets/images/pf4.jpg",
      "assets/images/pf5.jpg",
    ];

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
                    RichText(
                      text: const TextSpan(
                        text: 'Hello ',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: ',Jennifer!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.orangeAccent)),
                        ],
                      ),
                    ),

                    // right side of row
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications, size: 15),
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
                      height: 160,
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
                                      fontWeight: FontWeight.w500),
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

              // End of second row

              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's pick",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                          color: Colors.red[600], fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TodaysPickSlider(
                  recipes: meals, onCategorySelected: handleCategorySelected),
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              // Trainers

              TopTrainerSlider(
                recipes: trainers,
                onTrainerSelected: handleTrainerSelected,
                images: images,
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Nutritional News",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown),
                    ),
                  ],
                ),
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
