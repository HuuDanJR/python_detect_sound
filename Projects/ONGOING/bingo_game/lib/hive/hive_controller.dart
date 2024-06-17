import 'package:bingo_game/hive/model/round_model.dart';
import 'package:bingo_game/hive/model/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _boxName = 'round_box';
const String _boxNameSetting = 'setting_box';

class HiveController {
  HiveController._constructor();
  static final HiveController _instance = HiveController._constructor();
  factory HiveController() => _instance;
  late Box<RoundModel> _roundBox;
  late Box<SettingModel> _settingBox;

  Future<void> initialize() async {
    // Initialize the database
    await Hive.initFlutter();
    Hive.registerAdapter<RoundModel>(RoundModelAdapter());
    Hive.registerAdapter<SettingModel>(SettingModelAdapter());
    _roundBox = await Hive.openBox<RoundModel>(_boxName);
    _settingBox = await Hive.openBox<SettingModel>(_boxNameSetting);
  }

  Box<RoundModel> get roundBox => _roundBox;
  Box<SettingModel> get settingBox => _settingBox;

  Future<void> saveSetting(SettingModel setting) async {
    try {
      await _settingBox.put('settings', setting); // Save settings with a fixed key
      debugPrint('Settings saved');
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

   Future<void> updateSetting(SettingModel newSetting) async {
    try {
      await _settingBox.put('settings', newSetting); // Update settings with a fixed key
      // debugPrint('Settings updated');
    } catch (e) {
      debugPrint('Error updating settings: $e');
    }
  }

  

  Future<SettingModel?> getSetting() async {
    try {
      return _settingBox.get('settings'); // Retrieve settings with a fixed key
    } catch (e) {
      debugPrint('Error retrieving settings: $e');
      return null;
    }
  }

  Future<void> resetSetting() async {
    try {
      await _settingBox.delete('settings'); // Delete settings with a fixed key
      debugPrint('Settings reset');
    } catch (e) {
      debugPrint('Error resetting settings: $e');
    }
  }





  //ROUND

  Future<void> saveNewRound(RoundModel round) async {
    try {
      await _roundBox.add(round); // Add the new round to the box
      debugPrint('New round saved ${round.round} ${round.roundId}');
    } catch (e) {
      debugPrint('Error saving new round: $e');
    }
  }

  Future<void> addToLatestRound(List<int> newData) async {
    try {
      final latestRound = await getLatestRound(); // Get the latest round
      if (latestRound != null) {
        final updatedRound = List<int>.from(latestRound.round)
          ..addAll(newData); // Append newData to the existing round data
        latestRound.round = updatedRound; // Update the round data
        await latestRound.save(); // Save the updated round back to Hive
        // debugPrint('Data added to latest round: $updatedRound');
      } else {
        debugPrint('No latest round found');
      }
    } catch (e) {
      debugPrint('Error adding data to latest round: $e');
    }
  }

  Future<RoundModel?> getRoundById(String roundId) async {
    try {
      final round = _roundBox.values.firstWhere(
        (item) => item.roundId == roundId,
      );
      return round;
    } catch (e) {
      debugPrint('Error retrieving round with ID $roundId: $e');
      return null;
    }
  }

  Future<void> deleteRoundById(String roundId) async {
    try {
      final roundKey = await _roundBox.add(RoundModel(
          round: [],
          roundId: roundId,
          createAt:
              "")); // Create a temporary RoundModel with the specified roundId to get its key
      await _roundBox
          .delete(roundKey); // Delete the round with the given roundId
      debugPrint('Round with ID $roundId deleted');
    } catch (e) {
      debugPrint('Error deleting round with ID $roundId: $e');
    }
  }

  Future<void> deleteAllRounds() async {
    try {
      await _roundBox.clear(); // Clear all items from the box
      debugPrint('All rounds deleted');
    } catch (e) {
      debugPrint('Error deleting all rounds: $e');
    }
  }

  Future<RoundModel?> getLatestRound() async {
    try {
      final rounds =
          _roundBox.values.toList(); // Convert values to a list for sorting
      rounds.sort((a, b) => DateTime.parse(b.createAt).compareTo(
          DateTime.parse(a.createAt))); // Sort rounds by createAt descending
      if (rounds.isNotEmpty) {
        // print('getLatestRound: ${rounds.first.round} ${rounds.first.roundId}');
        return rounds.first; // Return the latest round
      } else {
        return null; // Return null if no rounds exist
      }
    } catch (e) {
      debugPrint('Error retrieving latest round: $e');
      return null;
    }
  }

  Future<List<RoundModel>> getAllRounds() async {
    try {
      final rounds = _roundBox.values.toList();
      print('getAllRounds ${rounds.length}');
      return rounds;
    } catch (e) {
      debugPrint('Error retrieving all rounds: $e');
      return [];
    }
  }
}
