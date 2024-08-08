import 'package:flutter/material.dart';
import 'package:voltican_fitness/models 2/meal.dart';
import 'package:voltican_fitness/screens/trainee_plan_detail.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TraineePlanDetailScreen(
                meal: Meal(
                    id: 'm2',
                    imageUrl:
                        "https://cdn.pixabay.com/photo/2017/03/27/13/54/bread-2178874_640.jpg",
                    ingredients: ["potatos", "fries"],
                    title: "Sandwich and Fries"))));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/recipe.jpg",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avodao Mix",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "A glutten free meal  for...",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
