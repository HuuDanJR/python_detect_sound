part of 'video_bloc.dart';

class MyVideoState extends Equatable {
  final VideoPlayerController? controller;
  final bool isLoading;
  final bool isPlaying;
  final String url;

  MyVideoState({
    required this.controller,
    required this.isLoading,
    required this.isPlaying,
    required this.url,
  });

  MyVideoState copyWith({
    VideoPlayerController? controller,
    bool? isLoading,
    bool? isPlaying,
    String? url,
  }) {
    return MyVideoState(
      controller: controller ?? this.controller,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      url:  url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [controller, isLoading, isPlaying];
}
