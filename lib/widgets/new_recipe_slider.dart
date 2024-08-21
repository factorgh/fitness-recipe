import 'package:flutter/material.dart';

class NewRecipeSlider extends StatelessWidget {
  final List<Map<String, dynamic>> recipes; // Updated to List<Recipe>
  final List<String> owners; // List of recipe owners
  final List<String> recipeTitles;
  final List<String> recipeImages;
  final Function(Map<String, dynamic>) onCategorySelected;

  const NewRecipeSlider({
    super.key,
    required this.recipes,
    required this.owners,
    required this.recipeImages,
    required this.onCategorySelected,
    required this.recipeTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length, // Assumes all lists are the same length
        itemBuilder: (context, index) {
          // Check if index is within bounds for all lists
          if (index < recipeImages.length &&
              index < owners.length &&
              index < recipeTitles.length) {
            return _buildRecipeItem(
              context,
              recipes[index],
              owners[index],
              recipeImages[index],
              recipeTitles[index],
            );
          } else {
            // Handle the case where index is out of bounds
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildRecipeItem(BuildContext context, Map<String, dynamic> recipe,
      String owner, String recipeImage, String recipeTitle) {
    return GestureDetector(
      onTap: () => onCategorySelected(recipe),
      child: Container(
        width: 330, // Adjust width as needed
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(recipeImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.amber,
                              ),
                              Text(
                                '4.5 (1k+ Reviews)',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 120,
                      ),
                      // Add Favorite Icon
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.favorite_border_outlined,
                              color: Colors.black12, size: 20),
                        ),
                      ),
                    ],
                  ),
                  // Short Description
                ],
              ),
            ),
            Positioned(
              top: 130,
              bottom: 0,
              child: Container(
                width: 330,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipeTitle,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.amber,
                              ),
                              const Text(
                                "35 min",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                ".",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'by',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                owner,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
