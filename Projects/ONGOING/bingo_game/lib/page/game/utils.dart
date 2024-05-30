import 'dart:math';

int generateUniqueNumber(Set<int> existingNumbers) {
  final random = Random();
  int number;
  do {
    number = random.nextInt(75) + 1; // Generate a number between 1 and 75
  } while (existingNumbers.contains(number)); // Ensure uniqueness
  return number;
}