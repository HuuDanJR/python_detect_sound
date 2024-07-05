
part of 'staff_bloc.dart';


enum StaffStatus { initial, loading, filtering, finish, error }

class StaffState extends Equatable {
  final StaffStatus status;
  final List<StaffModelData> staffList;
  final List<StaffModelData> filteredList;
  final StaffModelData? selectedStaff;
  final String? errorMessage;
  final bool showList;

  const StaffState({
    this.status = StaffStatus.initial,
    this.staffList = const [],
    this.filteredList = const [],
    this.selectedStaff,
    this.errorMessage,
    this.showList = false
  });

  StaffState copyWith({
    StaffStatus? status,
    List<StaffModelData>? staffList,
    List<StaffModelData>? filteredList,
    StaffModelData? selectedStaff,
    String? errorMessage,
    bool? showList,
  }) {
    return StaffState(
      status: status ?? this.status,
      staffList: staffList ?? this.staffList,
      filteredList: filteredList ?? this.filteredList,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      errorMessage: errorMessage ?? this.errorMessage,
      showList: showList ?? this.showList,
    );
  }
  

  @override
  List<Object?> get props => [status, staffList, filteredList, selectedStaff, errorMessage,showList];
}