// pickup_bloc.dart
import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:equatable/equatable.dart';

part 'pickup_event.dart';
part 'pickup_state.dart';

class PickupBloc extends Bloc<PickupEvent, PickupState> {
  late int totalLength;

  getInitSetting() {
    HiveController().getSetting().then((value) {
      if (value != null) {
        totalLength = value.totalRound;
      }
    });
  }

  PickupBloc() : super(const PickupState(pickups: [], selectedPickups: {})) {
    getInitSetting();
    on<GeneratePickups>(_onGeneratePickups);
    on<TogglePickupSelection>(_onTogglePickupSelection);
    on<GetAllSelected>(_onGetAllSelected);
  }

  void _onGeneratePickups(GeneratePickups event, Emitter<PickupState> emit) {
    final pickups = List<int>.generate(
        totalLength ?? ConfigFactory.LIST_LENGTH, (index) => index + 1);
    emit(state.copyWith(pickups: pickups));
  }

  void _onTogglePickupSelection(
      TogglePickupSelection event, Emitter<PickupState> emit) {
    final selectedPickups = Set<int>.from(state.selectedPickups);
    if (selectedPickups.contains(event.pickup)) {
      selectedPickups.remove(event.pickup);
    } else {
      selectedPickups.add(event.pickup);
    }
    emit(state.copyWith(selectedPickups: selectedPickups));
  }

  void _onGetAllSelected(GetAllSelected event, Emitter<PickupState> emit) {
    // This event handler doesn't need to change the state, it's used for UI purposes
  }
}
