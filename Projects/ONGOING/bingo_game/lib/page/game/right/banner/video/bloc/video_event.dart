// video_event.dart
part of 'video_bloc.dart';

abstract class MyVideoEvent extends Equatable {
  const MyVideoEvent();

  @override
  List<Object> get props => [];
}

class InitVideo extends MyVideoEvent {
  final String url;

  const InitVideo(this.url);

  @override
  List<Object> get props => [url];
}

class TogglePlayPause extends MyVideoEvent {}
