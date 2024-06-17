import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/model/ball.dart';
import 'package:bingo_game/page/game/bloc/timer/timer_bloc.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../bloc/ball/ball_bloc.dart';

class GameTimerPage extends StatelessWidget {
  const GameTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameTimerView();
  }
}

class GameTimerView extends StatefulWidget {
  const GameTimerView({super.key});

  @override
  State<GameTimerView> createState() => _GameTimerViewState();
}

class _GameTimerViewState extends State<GameTimerView> {
  late Uuid genId = const Uuid();
  @override
  void initState() {
    super.initState();
    HiveController().getSetting().then((v) {
       context.read<TimerBloc>().add( SkipTicks(v!.roundInitial.length)); // Skip 2 ticks
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final minutes = (state.duration ~/ 60).toString().padLeft(2, '0');
        final seconds = (state.duration % 60).toString().padLeft(2, '0');
        switch (state.status) {
          case TimerStatus.initial:
            if (state.isFirstRun) {
              // debugPrint('first run');
              addBallNew(id: state.tickCount, number: state.number, tag: '');
            } else {
              // debugPrint('not first run');
            }
            break;
          case TimerStatus.paused:
            break;
          case TimerStatus.ticking:
            // debugPrint('ticking state');
            break;
          case TimerStatus.finish:
            // debugPrint('TimerStatus.finish: ${state.tickCount} : ${state.number} ');
            addBallNew(id: state.tickCount, number: state.number, tag: '');
            break;
          case TimerStatus.failure:
            break;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            textCustomStyle(
              text: '$minutes:$seconds',
              size: StringFactory.padding24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: StringFactory.padding8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(  
                message:state.status == TimerStatus.paused? 'Resume Game' : 'Pause Game',
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Start the timer when the button is pressed
                    debugPrint('toggle pause / resume ');
                    context.read<TimerBloc>().add(TogglePauseResume(context));
                  },
                  icon:  Icon(state.status == TimerStatus.paused ? Icons.play_arrow : Icons.pause, color: MyColor.grey),
                  label: textCustom(text:state.status == TimerStatus.paused ? 'Resume':"Pause",color: MyColor.black_absulute),
                ),
              ),
              const SizedBox(width: StringFactory.padding8,),
              Tooltip(
                message: "Stop & Save Game",
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Start the timer when the button is pressed
                    context.read<TimerBloc>().add(StopTimer(context));
                  },
                  icon: const Icon(Icons.stop, color: MyColor.grey),
                  label: textCustom(text: 'stop',color: MyColor.black_absulute),
                ),
              ),
            ],
          ),
          ],
        );
      },
    );
  }

  //add new ball from bloc
  addBallNew({required int id, required int number, required String tag}) {
    final ball = Ball(
      id: id,
      number: number,
      tag: tag,
      isCreated: true,
      status: 'created',
    );
    context.read<BallBloc>().add(AddBall(ball: ball));
  }
}


