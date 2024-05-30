import 'dart:math';
//generate a number
int generateRandomNumber(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
}






List<List<int>> generateUniqueRandomGrid(int maxNumber) {
  // Check if maxNumber is at least 25 to generate unique numbers
  if (maxNumber < 25) {
    throw ArgumentError('maxNumber should be at least 25 to generate unique numbers');
  }
  final random = Random();
  final uniqueNumbers = <int>{};
  // Generate a set of unique random numbers
  while (uniqueNumbers.length < 25) {
    uniqueNumbers.add(random.nextInt(maxNumber) + 1);
  }
  final uniqueNumberList = uniqueNumbers.toList();
  // Create a 5x5 grid from the unique number list
  List<List<int>> grid = List.generate(5, (i) => List.generate(5, (j) => 0));
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      grid[i][j] = uniqueNumberList[i * 5 + j];
    }
  }
  return grid;
}