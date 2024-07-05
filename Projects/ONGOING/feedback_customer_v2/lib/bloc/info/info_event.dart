part of 'info_bloc.dart';



abstract class InfoEvent extends Equatable {
  const InfoEvent();
  @override
  List<Object> get props => [];
}

class LoadInfo extends InfoEvent {}

class SaveInfo extends InfoEvent {
  final Info info;
  const SaveInfo(this.info);

  @override
  List<Object> get props => [info];
}

class UpdateInfo extends InfoEvent {
  final Info info;
  const UpdateInfo(this.info);

  @override
  List<Object> get props => [info];
}

class RetrieveInfo extends InfoEvent {}
