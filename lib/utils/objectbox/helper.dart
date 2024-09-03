// import 'package:objectbox/objectbox.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:voltican_fitness/models/mealplan.dart';

// class ObjectBoxHelper {
//   late final Store store;
//   late final Box<MealPlan> mealPlanBox;
//   late final Box<Meal> mealBox;
//   late final Box<Recurrence> recurrenceBox;

//   ObjectBoxHelper._create(this.store) {
//     mealPlanBox = Box<MealPlan>(store);
//     mealBox = Box<Meal>(store);
//     recurrenceBox = Box<Recurrence>(store);
//   }

//   static Future<ObjectBoxHelper> init() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final store =
//         Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');
//     return ObjectBoxHelper._create(store);
//   }

//   // Insert MealPlan
//   Future<void> insertMealPlan(MealPlan mealPlan) async {
//     mealPlan.id = 0; // Reset ID for new entries
//     mealPlanBox.put(mealPlan);
//   }

//   // Insert Meal
//   Future<void> insertMeal(Meal meal) async {
//     meal.id = 0;
//     mealBox.put(meal);
//   }

//   // Insert Recurrence
//   Future<void> insertRecurrence(Recurrence recurrence) async {
//     recurrence.id = 0;
//     recurrenceBox.put(recurrence);
//   }

//   // Fetch all MealPlans
//   List<MealPlan> getMealPlans() {
//     return mealPlanBox.getAll();
//   }

//   // Fetch Meals by Date
//   List<Meal> getMealsByDate(DateTime date) {
//     return mealBox
//         .query(Meal_.date.equals(date.millisecondsSinceEpoch))
//         .build()
//         .find();
//   }

//   // Remove Meal
//   Future<void> removeMeal(int mealId) async {
//     mealBox.remove(mealId);
//   }

//   // Update Meals with MealPlan ID
//   Future<void> updateMealPlanId(int mealPlanId) async {
//     final meals = mealBox.getAll();
//     meals.forEach((meal) {
//       meal?.mealPlan.targetId = mealPlanId;
//     });
//     mealBox.putMany(meals);
//   }

//   // Get all MealPlans with Meals
//   List<MealPlan> getMealPlansWithMeals() {
//     final mealPlans = mealPlanBox.getAll();
//     return mealPlans;
//   }
// }
