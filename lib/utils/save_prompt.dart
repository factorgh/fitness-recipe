// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:voltican_fitness/models/mealplan.dart';

// Future<void> _handleMealCreation(Meal newMeal) async {
//   // Show a dialog or prompt to ask the user if they want to save to draft
//   Future<bool?> shouldSaveToDraft = await _showSaveToDraftPrompt();

//   if (await shouldSaveToDraft) {
//     // Ask the user if they want to set a recurrence or save for the current date
//     Recurrence? recurrence = await _showRecurrenceOptions();

//     if (recurrence != null) {
//       // Save with recurrence
//       await _saveMealWithRecurrence(newMeal, recurrence);
//     } else {
//       // Save for the current date
//       await _saveMealForCurrentDate(newMeal);
//     }

//     // Provide feedback to the user
//     _showSaveConfirmation();
//   } else {
//     // Handle case where the user does not want to save to draft
//     _showSaveCancelled();
//   }
// }

// Future<Future<bool?>> _showSaveToDraftPrompt(BuildContext context) async {
//   // Implement a dialog to ask if the user wants to save to draft
//   return showDialog<bool>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Save Meal'),
//       content: const Text('Do you want to save this meal to draft?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(true),
//           child: const Text('Save'),
//         ),
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: const Text('Cancel'),
//         ),
//       ],
//     ),
//   );
// }

// Future<Recurrence?> _showRecurrenceOptions() async {
//   // Implement a dialog to choose recurrence options
//   return showDialog<Recurrence>(
//     context: context,
//     builder: (context) => RecurrenceBottomSheet(
//         // Implement your recurrence options here
//         ),
//   );
// }

// Future<void> _saveMealForCurrentDate(Meal meal) async {
//   // Save the meal for the current date
//   await mealDraftService.saveMealForDate(DateTime.now(), meal);
// }

// Future<void> _saveMealWithRecurrence(Meal meal, Recurrence recurrence) async {
//   // Save the meal with recurrence options
//   await mealDraftService.saveMealWithRecurrence(meal, recurrence);
// }

// void _showSaveConfirmation() {
//   // Implement a dialog or message to confirm successful save
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Saved'),
//       content: const Text('Meal has been saved successfully.'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }

// void _showSaveCancelled() {
//   // Implement a dialog or message to inform that saving was cancelled
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Cancelled'),
//       content: const Text('Meal creation was cancelled.'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }
