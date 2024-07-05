import 'package:equatable/equatable.dart';
import 'package:feedback_customer/model/info.dart';
import 'package:feedback_customer/model/staff_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'info_event.dart';
part 'info_state.dart';



class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc() : super(const InfoState()) {
    on<LoadInfo>(_onLoadInfo);
    on<SaveInfo>(_onSaveInfo);
    on<UpdateInfo>(_onUpdateInfo);
    on<RetrieveInfo>(_onRetrieveInfo);
  }

  void _onLoadInfo(LoadInfo event, Emitter<InfoState> emit) {
    // Implement loading logic here
  }

  void _onSaveInfo(SaveInfo event, Emitter<InfoState> emit) {
    emit(state.copyWith(isLoading: true));

    try {
      // Implement save logic here (e.g., saving to a database)
      emit(state.copyWith(isSaved: true, isLoading: false, info: event.info));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }

  void _onUpdateInfo(UpdateInfo event, Emitter<InfoState> emit) {
    emit(state.copyWith(isLoading: true));
    try {
      // Implement update logic here (e.g., updating in a database)
      emit(state.copyWith(isUpdated: true, isLoading: false, info: event.info));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }

  void _onRetrieveInfo(RetrieveInfo event, Emitter<InfoState> emit) {
    emit(state.copyWith(isLoading: true));
    try {
      // Implement retrieve logic here (e.g., fetching from a database)
      final retrievedInfo = Info(
        suggestionName: 'John Doe',
        customerName: 'John Doe',
        customerNumber: 123,
        nationality: 'EN',
        languageApp: 'English',
        serviceBad: [],
        serviceGood: [],
        hasNote: false,
        note: '',
        hasEnterInputMemory: false,
        staff: StaffModelData(
          code: '000',
          username: 'default',
          usernameEn: 'default',
          imageUrl: 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          role: 'default', id: '', createdAt: DateTime.now(), isActive: false, v: 0,
        ),
        reachResultPage: true,
      );
      emit(state.copyWith(isLoading: false, info: retrievedInfo));
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }
}