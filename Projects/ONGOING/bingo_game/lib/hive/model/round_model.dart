import 'package:hive/hive.dart';
part 'round_model.g.dart';

@HiveType(typeId: 1) // Unique typeId for this model
class RoundModel extends HiveObject {
  RoundModel({
    required this.round,
    required this.roundId,
    required this.createAt,
  });

  @HiveField(0)
  List<int> round;
  @HiveField(1)
  String roundId;
  @HiveField(2)
  String createAt;
}
