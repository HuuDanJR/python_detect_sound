part of 'info_bloc.dart';


class InfoState extends Equatable {
  final Info? info;
  final bool isLoading;
  final bool isSaved;
  final bool isUpdated;
  final bool isError;

  const InfoState({
    this.info,
    this.isLoading = false,
    this.isSaved = false,
    this.isUpdated = false,
    this.isError = false,
  });

  InfoState copyWith({
    Info? info,
    bool? isLoading,
    bool? isSaved,
    bool? isUpdated,
    bool? isError,
  }) {
    return InfoState(
      info: info ?? this.info,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      isUpdated: isUpdated ?? this.isUpdated,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [info, isLoading, isSaved, isUpdated, isError];
}