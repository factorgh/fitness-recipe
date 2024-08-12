import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:voltican_fitness/models/recipe.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({super.key, required this.meal, required this.selectMeal});

  final Recipe meal;
  final void Function(Recipe meal) selectMeal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        selectMeal(meal);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: double.infinity,
          height: 180,
          child: Column(children: [
            FadeInImage(
              height: 100,
              width: double.infinity,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                      Text(
                        meal.title,
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 70,
                    height: 30,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '4.5',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.star, color: Colors.white, size: 15)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
