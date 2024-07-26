import 'package:flutter/material.dart';
import 'package:voltican_fitness/data/dummy_data.dart';
import 'package:voltican_fitness/models/meal.dart';
import 'package:voltican_fitness/screens/meal_detail_screen.dart';
import 'package:voltican_fitness/widgets/meal_item.dart';
import 'package:voltican_fitness/widgets/simple_button.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

void selectMeal(BuildContext context, Meal meal) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => MealDetailScreen(meal: meal),
  ));
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Meal Plans",
              style: TextStyle(fontSize: 25),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => print('Add Meal Plan'),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey[300],
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Trainer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search for meal plans",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black38,
                  )),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            SimpleButton(
                title: 'Popularity',
                backColor: Colors.red,
                size: 12,
                textColor: Colors.white),
            SizedBox(width: 5),
            SimpleButton(
                title: 'Rating',
                backColor: Colors.white,
                size: 12,
                textColor: Colors.black45),
            SizedBox(width: 5),
            SimpleButton(
                title: 'Dietary',
                backColor: Colors.white,
                size: 15,
                textColor: Colors.black54),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: dummyMeals.length,
            itemBuilder: (context, index) => MealItem(
              meal: dummyMeals[index],
              selectMeal: (meal) {
                selectMeal(context, meal);
              },
            ),
          ),
        )
      ]),
    );
  }
}
