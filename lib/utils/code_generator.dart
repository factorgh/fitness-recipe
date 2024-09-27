// ignore_for_file: avoid_print

import 'dart:math';

import 'package:voltican_fitness/models/user.dart';

class CodeGenerator {
  final Set<int> _generatedNumbers = {};

  // Gen a unique code based on the user's full name
  String generateCode(String fullName) {
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

// Generates and sends codes to backend for all trainers
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
