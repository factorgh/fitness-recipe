import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/user.dart';

class CodeGenerator {
  final Set<int> _generatedNumbers = {};

  Strinde(String fullName) {
    String firstLetter = fullName[0];
    String lastLetter = fullName[fullName.length - 1];

    int uniqueNumber = _generateUniqueNumber();

    return '$firstLetter$lastLetter$uniqueNumber';
  }

  int _generateUniqueNumber() {
    final random = Random();
    int number;

    do {
      number = random.nextInt(9000) + 1000; // Generates a 4-digit number
    } while (_generatedNumbers.contains(number));

    _generatedNumbers.add(number);
    return number;
  }
}

void generateAndSendCodes(List<User> trainers) {
  CodeGenerator codeGenerator = CodeGenerator();

  for (var trainer in trainers) {
    if (trainer.role == "1") {
      String code = codeGenerator.generateCode(trainer.fullName);
      // Send this code to the backend for storage
      print('Generated code for ${trainer.fullName}: $code');
      // Implement your backend call here
    }
  }
}

void onProceed(
  User user,
  BuildContext context,
) async {
  if (user.role != "1") {
    user.role = "1"; // Set the role to trainer
  }

  CodeGenerator codeGenerator = CodeGenerator();
  String generatedCode = codeGenerator.generateCode(user.fullName);

  // Create a payload to send to the backend
  Map<String, dynamic> updatedUserData = {
    "role": user.role,
    "code": generatedCode,
  };

  // Send the updated data to the backend
  bool isUpdated = await updateUserOnBackend(user.id, updatedUserData);

  if (isUpdated) {
    // Navigate to the home screen if the update is successful
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Handle error (e.g., show a snackbar or alert)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update user. Please try again.')),
    );
  }
}

Future<bool> updateUserOnBackend(
    String userId, Map<String, dynamic> data) async {
  try {
    // Assuming you have a Dio client set up for API requests
    final response = await dio.put('/users/$userId', data: data);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    // Handle error appropriately (e.g., log error or retry)
    return false;
  }
}
