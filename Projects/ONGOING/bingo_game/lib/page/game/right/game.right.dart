import 'package:bingo_game/page/game/right/ball_view/game.display.dart';
import 'package:bingo_game/page/game/right/banner/game.video.dart';
import 'package:bingo_game/page/game/right/export.dart';

class GameRightPage extends StatelessWidget {
  const GameRightPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      width: ConfigFactory.ratio_width_parent(width: width),
      child: 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GameDisplay(width: ConfigFactory.ratio_width_parent(width: width), height: ConfigFactory.ratio_height_parent(height: height)),
            GameVideoPage(width: ConfigFactory.ratio_width_parent(width: width), height: ConfigFactory.ratio_height_child(height: height)),
            // GameBanner(width: ConfigFactory.ratio_width_parent(width: width), height: ConfigFactory.ratio_height_child(height: height)),
          ],
        ),
     
    );
  }
}
