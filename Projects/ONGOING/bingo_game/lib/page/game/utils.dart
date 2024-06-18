import 'dart:math';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/public/config.dart';


generateUniqueNumber(List<int> existingNumbers, {bool initial = false}) {
  int listLength = ConfigFactory.LIST_LENGTH;
  if (!initial && existingNumbers.length >= listLength) {
    throw Exception("All numbers from 1 to $listLength are already used.");
  }
  final random = Random();
  int number;
  if (initial) {
    number =
        random.nextInt(listLength) + 1; // Generate a number between 1 and 75
  } else {
    do {
      number = random.nextInt(listLength) + 1; // Generate a number between 1 and 75
      if (existingNumbers.contains(number)) {
      }
    } while (existingNumbers.contains(number)); // Ensure uniqueness
  }
  // debugPrint('generateUniqueNumber: $number');
  return number;
}



//generate random string 7 tota length

String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(random.nextInt(characters.length)),
    ),
  );
}