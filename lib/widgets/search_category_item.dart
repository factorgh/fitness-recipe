import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/recipe.dart';

class SearchCategoryItem extends StatelessWidget {
  final Recipe recipe;

  const SearchCategoryItem({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(recipe.imageUrl),
        title: Text(recipe.title),
        subtitle: Text('Rating: ${recipe.averageRating.toStringAsFixed(1)}'),
        onTap: () {
          // Navigate to recipe details screen if needed
        },
      ),
    );
  }
}
