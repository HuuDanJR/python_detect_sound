import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:bingo_game/page/game/bloc/timer/timer_bloc.dart';
import 'package:bingo_game/page/game/game.dart';
import 'package:bingo_game/page/game/right/banner/game.video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:video_player_web_hls/video_player_web_hls.dart';

void main() {
  // Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized(); //Media Kit
  MediaKit.ensureInitialized();
  
  VideoPlayerPlugin.registerWith(null); //Register web implementation

  runApp(const MyApp()); //Run App
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bingo Game',
        theme: ThemeData(
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<TimerBloc>(
              create: (context) {
                final timerBloc = TimerBloc();
                timerBloc.add(StartTimer(context)); // Dispatch StartTimer event here
                return timerBloc;
              },
            ),
            BlocProvider<BallBloc>(
              create: (context) => BallBloc(),
            ),
          ],
          // child: const HomePage(),
          child: const GamePage(),
          // child: GameVideoPage(
          //   width: width,
          //   height: height,
          // ),
        ));
  }
}
