import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/page/admin/home.dart';
import 'package:bingo_game/page/admin/switch/export.dart';
import 'package:bingo_game/page/pickup/bloc/pickup_bloc.dart';
import 'package:bingo_game/page/play/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:video_player_web/video_player_web.dart";

void main() async {
  // Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized(); //Media Kit
  VideoPlayerPlugin.registerWith(null); //Register web implementation
  await HiveController().initialize();
  // HiveController().deleteAllRounds(); // Call your HiveController to initialize

  runApp(const MyApp()); //Run App
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bingo Game',
        theme: ThemeData(
          // fontFamily: 'LibreBaskerville',
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            // BlocProvider<TimerBloc>( create: (context) => TimerBloc()..add(StartTimer(context))),
            // BlocProvider<BallBloc>(
            //   create: (context) => BallBloc(),
            // ),
            BlocProvider(
              create: (context) => PickupBloc(),
            ),
            BlocProvider<SwitchBloc>(
              create: (context) => SwitchBloc(),
            ),
            BlocProvider<GameBloc>(
              create: (context) => GameBloc()..add(FetchGames()),
            ),
          ],
          child: const HomePage(),
          // child: const GamePage(),
        ));
  }
}
