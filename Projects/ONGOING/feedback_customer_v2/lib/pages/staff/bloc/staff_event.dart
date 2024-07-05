part of 'staff_bloc.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object> get props => [];
}

class LoadStaff extends StaffEvent {}

class FilterStaff extends StaffEvent {
  final String query;

  const FilterStaff(this.query);

  @override
  List<Object> get props => [query];
}

class SelectStaff extends StaffEvent {
  final StaffModelData selectedStaff;

  const SelectStaff(this.selectedStaff);

  @override
  List<Object> get props => [selectedStaff];
}