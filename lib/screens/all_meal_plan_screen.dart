import 'package:flutter/material.dart';

import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlan extends StatefulWidget {
  const AllMealPlan({super.key});

  @override
  State<AllMealPlan> createState() => _AllMealPlanState();
}

class _AllMealPlanState extends State<AllMealPlan> {
  DateTime? _selectedDate;

  // get date picker funtion
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: const Text(
          'All Meal plans',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () => _pickDate(context),
            child: Text(
              _selectedDate == null
                  ? 'Filter'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: "Baked Salmon with strwaberries",
            ),
            SizedBox(
              height: 10,
            ),
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: "Baked Salmon with strwaberries",
            ),
            SizedBox(
              height: 10,
            ),
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: "Baked Salmon with strwaberries",
            ),
            SizedBox(
              height: 10,
            ),
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: "Baked Salmon with strwaberries",
            ),
            SizedBox(
              height: 10,
            ),
            CalendarItem(
              titleIcon: Icons.restaurant_menu,
              mealPlan: "Baked Salmon with strwaberries",
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
