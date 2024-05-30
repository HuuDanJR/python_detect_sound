import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:bingo_game/page/game/bloc/timer/timer_bloc.dart';
import 'package:bingo_game/page/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bingo Game',
        theme: ThemeData(
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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
          child: const GamePage(),
        ));
  }
}
