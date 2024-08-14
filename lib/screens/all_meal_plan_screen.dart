import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Add this package to your pubspec.yaml
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/providers/meal_plan_provider.dart';
import 'package:voltican_fitness/widgets/calendar_item.dart';

class AllMealPlan extends ConsumerStatefulWidget {
  const AllMealPlan({super.key});

  @override
  ConsumerState<AllMealPlan> createState() => _AllMealPlanState();
}

class _AllMealPlanState extends ConsumerState<AllMealPlan> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;
  List<MealPlan> _mealPlans = []; // Initialize as empty list

  @override
  void initState() {
    super.initState();
    _fetchMealPlans();
  }

  Future<void> _fetchMealPlans() async {
    final meals = ref.watch(mealPlansProvider);
    setState(() {
      _isLoading = true;

      _errorMessage = null;
    });

    try {
      // Replace the following line with your actual API call
      _mealPlans = meals;
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load meal plans.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Meal Plans',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => _pickDate(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _mealPlans.isEmpty
                    ? const Center(child: Text('No meal plans available.'))
                    : ListView.builder(
                        itemCount: _mealPlans.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CalendarItem(
                              titleIcon: Icons.restaurant_menu,
                              mealPlan: _mealPlans[index],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
