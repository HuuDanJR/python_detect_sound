import 'dart:math';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/public/config.dart';

// int generateUniqueNumber(Set<int> existingNumbers) {
//   if (existingNumbers.length >= ConfigFactory.LIST_LENGTH) {
//     throw Exception("All numbers from 1 to ${ConfigFactory.LIST_LENGTH} are already used.");
//   }

//   final random = Random();
//   int number;
//   do {
//     number = random.nextInt(ConfigFactory.LIST_LENGTH) + 1; // Generate a number between 1 and 75
//   } while (existingNumbers.contains(number)); // Ensure uniqueness
//   return number;
// }


int generateUniqueNumber(List<int> existingNumbers, {bool initial = false}) {
  if (!initial && existingNumbers.length >= ConfigFactory.LIST_LENGTH) {
    throw Exception("All numbers from 1 to ${ConfigFactory.LIST_LENGTH} are already used.");
  }

  final random = Random();
  int number;
  if (initial) {
    number = random.nextInt(ConfigFactory.LIST_LENGTH) + 1; // Generate a number between 1 and 75
  } else {
    do {
      number = random.nextInt(ConfigFactory.LIST_LENGTH) + 1; // Generate a number between 1 and 75
      if (existingNumbers.contains(number)) {
        // debugPrint('Duplicate found: $number');
      }
    } while (existingNumbers.contains(number)); // Ensure uniqueness
  }
  // debugPrint('generateUniqueNumber: $number');
  return number;
}