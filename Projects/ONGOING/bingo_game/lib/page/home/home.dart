import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/home/banner.dart';
import 'package:bingo_game/page/home/slide.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/text_field.dart';

import '../../widget/text.custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerTotalRound = TextEditingController();
  final TextEditingController controllerTimeRound = TextEditingController();
  final socket_manager = SocketManager();

  @override
  void initState() {
    socket_manager.initSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    socket_manager.disposeSocket();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = const TextTheme().titleMedium;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      debugPrint('reset game');
                    },
                    label: textcustom('RESET GAME', textTheme)),
                const SizedBox(
                  width: StringFactory.padding,
                ),
                ElevatedButton.icon(
                    icon: const Icon(Icons.gamepad),
                    onPressed: () {
                      debugPrint('start game');
                    },
                    label: textcustom('START GAME', textTheme)),
              ],
            ),
          ],
          centerTitle: false,
          backgroundColor: Colors.blue,
          title: textCustomNormalColor(
              text: 'Bingo Game Settings', color: MyColor.white),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(StringFactory.padding18),
            height: height,
            width: width,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width,
                    height: StringFactory.padding42,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mytextfield(width:width/3,height:StringFactory.padding42,controller: controllerTimeRound , hint: "Round Time",textInit: '${ConfigFactory.timer_duration_time} seconds'),
                        mytextfield(width:width/3,height:StringFactory.padding42,controller: controllerTotalRound, hint: "Total Round",textInit: '${ConfigFactory.LIST_LENGTH} rounds'),
                      ],
                    ),
                  ),
                  textCustom(
                          text: "Image Slide",
                          color: MyColor.black_text,
                  ),
                  SlidePage(
                    socketManager: socket_manager,
                  ),
                  textCustom(text: "Image Banner", color: MyColor.black_text),
                  BannerPage(
                    socketManager: socket_manager,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
