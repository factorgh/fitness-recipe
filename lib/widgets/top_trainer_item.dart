import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class TrainerRecipeItem extends StatelessWidget {
  const TrainerRecipeItem({
    super.key,
    required this.recipe,
    required this.selectMeal,
  });

  final Map<String, dynamic> recipe;
  final void Function(Map<String, dynamic> recipe) selectMeal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectMeal(recipe);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: Column(
            children: [
              FadeInImage(
                height: 100,
                width: double.infinity,
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(recipe['imageUrl'] ?? ''),
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['title'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            recipe['title'] ?? '',
                            style: const TextStyle(color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 30,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (recipe['averageRating'] ?? 0.0).toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.star, color: Colors.white, size: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
