import 'package:bingo_game/page/game/right/export.dart';
import 'package:video_player/video_player.dart';

import 'video_bloc.dart';


class GameVideoPlayBlocPage extends StatelessWidget {
  final double width;
  final double height;
  final String url;

  const GameVideoPlayBlocPage({super.key, required this.width, required this.height, required this.url});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc(),
      child: BlocBuilder<VideoBloc, MyVideoState>(
        builder: (context, state) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(StringFactory.padding56),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(StringFactory.padding56),
                      color: MyColor.black_absulute,
                    ),
                    width: width,
                    height: height,
                    child:  state.controller != null
                            ? VideoPlayer(state.controller!)
                            : const SizedBox(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}