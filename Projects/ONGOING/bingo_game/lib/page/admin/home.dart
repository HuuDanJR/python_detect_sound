import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/hive/model/setting_model.dart';
import 'package:bingo_game/page/game/game.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/banner/game.video_display.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/admin/banner.dart';
import 'package:bingo_game/page/admin/slide.dart';
import 'package:bingo_game/page/admin/switch/view/switch_view.dart';
import 'package:bingo_game/page/pickup/pickup_page.dart';
import 'package:bingo_game/page/play/game_played.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/socket/socket_manager.dart';
import 'package:bingo_game/widget/text_field.dart';

import '../../widget/text.custom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controllerTotalRound =
      TextEditingController(text: '${ConfigFactory.LIST_LENGTH}');
  final TextEditingController controllerTimeRound =
      TextEditingController(text: '${ConfigFactory.timer_duration_time}');
  final socket_manager = SocketManager();

  @override
  void initState() {
    socket_manager.initSocket();
    HiveController().saveSetting(SettingModel(
        roundInitial: [],
        timeDuration: ConfigFactory.timer_duration_time,
        totalRound: ConfigFactory.LIST_LENGTH));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    socket_manager.disposeSocket();
    HiveController().resetSetting();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = const TextTheme().titleMedium;
    return
        // BlocProvider(
        // create: (contextBloc) => PickupBloc()..add(GeneratePickups()),
        // child:
        Scaffold(
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
                          debugPrint('resume game');
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: textCustom(
                                        color: MyColor.black_absulute,
                                        text: "RESUME GAME"),
                                    backgroundColor: MyColor.grey_BG_main,
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          textcustom(
                                              '+Total rounds: ${controllerTotalRound.text}',
                                              textTheme),
                                          textcustom(
                                              '+Seconds/Round: ${controllerTimeRound.text}',
                                              textTheme),
                                          const Divider(),
                                          textcustom(
                                              'Pick numbers to resume game',
                                              textTheme),
                                          const PickUpPage()
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('CANCEL')),
                                      TextButton(
                                          onPressed: () {
                                            HiveController()
                                                .getSetting()
                                                .then((v) {
                                              print(
                                                  'setting get:${v!.roundInitial} ${v.timeDuration} ${v.totalRound}');
                                              HiveController().updateSetting(
                                                  SettingModel(
                                                      roundInitial:
                                                          v.roundInitial,
                                                      timeDuration: int.parse(
                                                          controllerTimeRound
                                                              .text),
                                                      totalRound: int.parse(
                                                          controllerTotalRound
                                                              .text)));
                                            });
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const GamePage()));
                                          },
                                          child: const Text('CONFIRM')),
                                    ],
                                  ));
                        },
                        label: textcustom('RESUME GAME', textTheme)),
                    const SizedBox(
                      width: StringFactory.padding,
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.gamepad),
                        onPressed: () {
                          debugPrint('start game');
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: textCustom(
                                        color: MyColor.black_absulute,
                                        text: "START GAME"),
                                    backgroundColor: MyColor.grey_BG_main,
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        textcustom(
                                            '+Total rounds: ${controllerTotalRound.text}',
                                            textTheme),
                                        textcustom(
                                            '+Seconds/Round: ${controllerTimeRound.text}',
                                            textTheme),
                                        const Divider(),
                                        textcustom(
                                            'Apply this setting for this game?',
                                            textTheme),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('CANCEL')),
                                      TextButton(
                                          onPressed: () {
                                            HiveController().saveSetting(
                                                SettingModel(
                                                    roundInitial: [],
                                                    timeDuration: int.parse(
                                                        controllerTimeRound
                                                            .text),
                                                    totalRound: int.parse(
                                                        controllerTotalRound
                                                            .text)));

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const GamePage()));
                                          },
                                          child: const Text('CONFIRM')),
                                    ],
                                  ));
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
                      textCustom(
                        text: "Games Played History",
                        color: MyColor.black_text,
                      ),
                      const GamePlayedPage(),
                      textCustom(
                        text: "Game Settings",
                        color: MyColor.black_text,
                      ),
                      SizedBox(
                        width: width,
                        height: StringFactory.padding42,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            mytextfield(
                                enable: true,
                                onChange: (v) {},
                                onFieldSubmitted: (v) {
                                  print('submit value: $v');
                                },
                                width: width / 3,
                                height: StringFactory.padding42,
                                controller: controllerTimeRound,
                                hint: "Round Time",
                                textInit:'Seconds to generate a number'),
                            const SizedBox(
                              width: StringFactory.padding16,
                            ),
                            mytextfield(
                                enable: false,
                                onChange: (v) {
                                  HiveController().saveSetting(SettingModel(
                                      roundInitial: [],
                                      timeDuration: int.parse(controllerTimeRound.text),
                                      totalRound: int.parse(v)));
                                },
                                onFieldSubmitted: (v) {
                                  print('submit value: $v');
                                  HiveController().saveSetting(SettingModel(
                                      roundInitial: [],
                                      timeDuration:
                                          int.parse(controllerTimeRound.text),
                                      totalRound: int.parse(v)));
                                },
                                width: width / 3,
                                height: StringFactory.padding42,
                                controller: controllerTotalRound,
                                hint: "Total Round",
                                textInit:
                                    '${ConfigFactory.LIST_LENGTH} rounds'),
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
                      SizedBox(
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SwitchButton(
                              socketManager: socket_manager,
                            ),
                            textCustom(
                                color: MyColor.black_absulute,
                                text:
                                    "Switch to choose image or videos for banner"),
                          ],
                        ),
                      ),
                      textCustom(
                          text: "Image Banner", color: MyColor.black_text),
                      BannerPage(
                        socketManager: socket_manager,
                      ),
                      textCustom(
                          text: "Video Banner", color: MyColor.black_text),
                      VideoDisplayPage(
                        socketManager: socket_manager,
                      ),
                      // textCustom(text: "Display ", color: MyColor.black_text),
                      // DisplayPage(
                      //   socketManager: socket_manager,
                      //   childActive: Text('active'),
                      //   childUnActive: Text('unactive'),
                      // ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       socket_manager.eventChangeDisplay();
                      //     },
                      //     child: Text('switch'))
                    ],
                  ),
                ),
              ),
            ));
  }
}
