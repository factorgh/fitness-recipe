import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/search_screen.dart';

class CategorySlider extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategorySlider({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Adjust height as needed
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryItem(context, categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SearchScreen())),
      child: Container(
        width: 150, // Adjust width as needed
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: const DecorationImage(
                  image: AssetImage("assets/recipe.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
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
