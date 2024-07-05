import 'package:equatable/equatable.dart';
import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/model/staff_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final ServiceAPIs staffRepository;

  StaffBloc(this.staffRepository) : super(const StaffState()) {
    on<LoadStaff>(_onLoadStaff);
    on<FilterStaff>(_onFilterStaff);
    on<SelectStaff>(_onSelectStaff);
  }

  void _onLoadStaff(LoadStaff event, Emitter<StaffState> emit) async {
    emit(state.copyWith(status: StaffStatus.loading));
    try {
      final staffList = await staffRepository.getListAllStaff();
      emit(state.copyWith(
        status: StaffStatus.finish,
        staffList: staffList.data,
        filteredList: staffList.data,
        showList: false
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StaffStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFilterStaff(FilterStaff event, Emitter<StaffState> emit) {
    emit(state.copyWith(status: StaffStatus.filtering));
    final query = event.query.toLowerCase();
    final filteredList = state.staffList.where((staff) {
      return staff.usernameEn.toLowerCase().contains(query) ||  staff.code.toLowerCase().contains(query);
    }).toList();
    emit(state.copyWith(
      status: StaffStatus.finish,
      filteredList: filteredList,
      showList: query.isNotEmpty,
    ));
  }

  void _onSelectStaff(SelectStaff event, Emitter<StaffState> emit) {
    emit(state.copyWith(
      selectedStaff: event.selectedStaff,
    ));
  }
}
