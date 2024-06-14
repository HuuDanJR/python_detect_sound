part of 'pickup_bloc.dart';

class PickupState extends Equatable {
  final List<int> pickups;
  final Set<int> selectedPickups;

  const PickupState({required this.pickups, required this.selectedPickups});

  PickupState copyWith({
    List<int>? pickups,
    Set<int>? selectedPickups,
  }) {
    return PickupState(
      pickups: pickups ?? this.pickups,
      selectedPickups: selectedPickups ?? this.selectedPickups,
    );
  }

  @override
  List<Object> get props => [pickups, selectedPickups];
}