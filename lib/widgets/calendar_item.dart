import 'package:flutter/material.dart';
// import 'package:voltican_fitness/screens/meal_edit_screen.dart';
import 'package:voltican_fitness/widgets/simple_button.dart';

class CalendarItem extends StatelessWidget {
  final String mealPlan;
  final IconData titleIcon;
  const CalendarItem(
      {super.key, required this.mealPlan, required this.titleIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            leading: Icon(titleIcon),
            title: Text(mealPlan),
            trailing: const Icon(Icons.arrow_drop_down),
            shape: Border.all(color: Colors.transparent),
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.schedule),
                  SizedBox(
                    width: 20,
                  ),
                  Text("10:30 AM")
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text('Trainees'),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/onboarding_3.png")),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/onboarding_3.png")),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/onboarding_3.png")),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/onboarding_3.png")),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(" and 25 others")
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    SimpleButton(
                        title: "delete",
                        backColor: Colors.red,
                        size: 100,
                        textColor: Colors.white),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
