import 'package:flutter/material.dart';
import 'package:voltican_fitness/models 2/meal.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final List<Map<String, String>> recipes = [
    {
      'name': 'Spaghetti Carbonara',
      'owner': 'Albert M.',
      'image': 'assets/recipe.jpg',
    },
    {
      'name': 'Chicken Alfredo',
      'owner': 'Ernest A.',
      'image': 'assets/images/pf.jpg',
    },
    // Add more recipes here
  ];

  @override
  Widget build(BuildContext context) {
    void handleRecipSelected() {
      // Handle category selection
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TrainerMealDetailScreen(
                    meal: Meal(
                        id: 'm2',
                        imageUrl:
                            "https://cdn.pixabay.com/photo/2017/03/27/13/54/bread-2178874_640.jpg",
                        ingredients: ["potatos", "fries"],
                        title: "Sandwich and Fries"),
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BreakFast'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return GestureDetector(
                    onTap: () => handleRecipSelected(),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                recipe['image']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['name']!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  recipe['owner']!,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
