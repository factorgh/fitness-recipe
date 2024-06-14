import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/calendar_screen.dart';

import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/widgets/simple_button.dart';

class MealEditScreen extends StatefulWidget {
  const MealEditScreen({super.key});

  @override
  State<MealEditScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<MealEditScreen> {
  Future<void> _openDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text('Are you sure you want to leave?If you \n'
            'leave changes will not be applied\n'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CalendarScreen()));
            },
            child: const SimpleButton(
                title: "Discard",
                backColor: Colors.white,
                size: 100,
                textColor: Colors.black),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const SimpleButton(
                title: "Save changes",
                backColor: Colors.red,
                size: 100,
                textColor: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _openDialog(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                ),
              ),
              const Text(
                'Edit meal plan ',
                style: TextStyle(fontSize: 15),
              ),
              const Text('1/2')
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Text('Add thumbnail image'),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 30,
                  ),
                  Text('upload')
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Enter meal plan'),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black38,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter meal name",
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Description'),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black38,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter meal description",
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Ingredients'),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.black38,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Which ingredients was used in this meal",
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const ButtonWidget(
                backColor: Colors.red, text: 'Next', textColor: Colors.white),
          )
        ],
      ),
    ));
  }
}
