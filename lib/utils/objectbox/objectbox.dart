import 'package:voltican_fitness/models/mealplan.dart';

import 'package:voltican_fitness/objectbox.g.dart'; // Assuming you have these models

class ObjectBox {
  late final Store _store;
  late final Box<Meal> mealBox;
  late final Box<MealPlan> mealPlanBox;

  // Private constructor
  ObjectBox._create(this._store) {
    // Initialize boxes for Meal and MealPlan
    mealBox = Box<Meal>(_store);
    mealPlanBox = Box<MealPlan>(_store);
  }

  // Create an instance of ObjectBox asynchronously
  static Future<ObjectBox> create() async {
    final store = await openStore(); // Corrected: Open the store
    return ObjectBox._create(store);
  }

  // Opening the store, no need for recursion
  static Future<Store> openStore() async {
    // Assuming the store is generated and available
    return Store(getObjectBoxModel());
  }

  // Close the store
  void close() {
    _store.close();
  }
}
