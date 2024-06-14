import 'package:bingo_game/page/game/left/export.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';
part 'video_state.dart';
part 'video_event.dart';


class VideoBloc extends Bloc<MyVideoEvent, MyVideoState> {
  VideoBloc() : super(MyVideoState(controller: null, isLoading: true, isPlaying: false,url: '')) {
    on<InitVideo>(_onInitVideo);
    on<TogglePlayPause>(_onTogglePlayPause);
  }

  Future<void> _onInitVideo(InitVideo event, Emitter<MyVideoState> emit) async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(event.url));
    await controller.initialize();
    controller.play();  // Start playing automatically
    emit(state.copyWith(controller: controller, isLoading: false, isPlaying: true));
  }

  void _onTogglePlayPause(TogglePlayPause event, Emitter<MyVideoState> emit) {
    final isPlaying = !state.isPlaying;
    if (state.controller != null) {
      if (isPlaying) {
        state.controller!.play();
      } else {
        state.controller!.pause();
      }
      emit(state.copyWith(isPlaying: isPlaying));
    }
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}