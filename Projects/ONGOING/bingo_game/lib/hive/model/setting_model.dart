import 'package:hive/hive.dart';

part 'setting_model.g.dart';

@HiveType(typeId: 0)
class SettingModel extends HiveObject {
  @HiveField(0)
  List<int> roundInitial;

  @HiveField(1)
  int timeDuration;

  @HiveField(2)
  int totalRound;

  SettingModel({
    required this.roundInitial,
    required this.timeDuration,
    required this.totalRound,
  });
}