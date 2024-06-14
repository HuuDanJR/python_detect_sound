import 'package:bingo_game/page/admin/display/display_page.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/ball_view/game.display.dart';
import 'package:bingo_game/page/game/right/banner/game.banner.dart';
import 'package:bingo_game/page/game/right/banner/game.video_list.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/socket/socket_manager.dart';

class GameRightPage extends StatefulWidget {
  const GameRightPage({super.key});
  

  @override
  State<GameRightPage> createState() => _GameRightPageState();
}

class _GameRightPageState extends State<GameRightPage> {
  late final socketManager = SocketManager();
  @override
  void initState() {
    socketManager.initSocket();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    socketManager.disposeSocket();
  }
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
            DisplayPage(
                    socketManager: socketManager,
                    childActive:   
                    VideoListPage(
                      width: ConfigFactory.ratio_width_parent(width: width)-(StringFactory.padding24*2), height: ConfigFactory.ratio_height_child(height: height)-(StringFactory.padding24),
                      socketManager:socketManager
                    ),
                    childUnActive:  GameBanner(width: ConfigFactory.ratio_width_parent(width: width)-(StringFactory.padding24*2), height: ConfigFactory.ratio_height_child(height: height) -(StringFactory.padding24)),
                  ),
            // GameVideoPlay(width: ConfigFactory.ratio_width_parent(width: width-(StringFactory.padding24*2)), height: ConfigFactory.ratio_height_child(height: height)-StringFactory.padding16),
            // GameBanner(width: ConfigFactory.ratio_width_parent(width: width)-(StringFactory.padding24*2), height: ConfigFactory.ratio_height_child(height: height)),
          ],
        ),
     
    );
  }
}
