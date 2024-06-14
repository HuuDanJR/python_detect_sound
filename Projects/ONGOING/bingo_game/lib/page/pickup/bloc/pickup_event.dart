// pickup_event.dart
part of 'pickup_bloc.dart';

abstract class PickupEvent extends Equatable {
  const PickupEvent();

  @override
  List<Object> get props => [];
}

class TogglePickupSelection extends PickupEvent {
  final int pickup;

  const TogglePickupSelection(this.pickup);

  @override
  List<Object> get props => [pickup];
}

class GetAllSelected extends PickupEvent {
  const GetAllSelected();
}
class GeneratePickups extends PickupEvent {}