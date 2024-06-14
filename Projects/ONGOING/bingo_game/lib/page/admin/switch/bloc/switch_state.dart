// switch_state.dart

part of 'switch_bloc.dart';

abstract class SwitchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SwitchOn extends SwitchState {}

class SwitchOff extends SwitchState {}