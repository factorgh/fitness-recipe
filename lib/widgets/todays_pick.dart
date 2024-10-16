import 'package:flutter/material.dart';

class TodaysPickSlider extends StatelessWidget {
  final List<String> recipes;
  final Function(String) onCategorySelected;

  const TodaysPickSlider({
    super.key,
    required this.recipes,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return _buildPlanItem(context, recipes[index]);
        },
      ),
    );
  }

  Widget _buildPlanItem(BuildContext context, String recipe) {
    return GestureDetector(
      onTap: () => onCategorySelected(recipe),
      child: Container(
        width: 330,
        // Adjust width as needed
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bread and Eggs",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("Morning Casserole",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("Egg,garlic,clove medium",
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("assets/recipe.jpg"),
                      fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }
}
