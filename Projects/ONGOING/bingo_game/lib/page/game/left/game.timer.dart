
import 'package:bingo_game/model/ball.dart';
import 'package:bingo_game/page/game/bloc/timer/timer_bloc.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  @override
  void initState() {
    print('initstate');
    super.initState();
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
              debugPrint('first run');
              addBallNew(id: state.tickCount, number: state.number, tag: '');
            } else {
              debugPrint('not first run');
            }
            break;
          case TimerStatus.ticking:
            debugPrint('ticking state');
            break;
          case TimerStatus.finish:
            debugPrint('finish state');
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
              size: StringFactory.padding20,
              fontWeight: FontWeight.bold,
            ),
            // Text(
            //   state.isFirstRun
            //       ? 'This is the first run!'
            //       : 'This is not the first run.',
            // ),
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

// const SizedBox(height: StringFactory.padding8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Start the timer when the button is pressed
//                 },
//                 icon: const Icon(Icons.pause, color: MyColor.grey),
//                 label: textCustom(text: 'pause'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Start the timer when the button is pressed
//                 },
//                 icon: const Icon(Icons.play_arrow, color: MyColor.grey),
//                 label: textCustom(text: 'resume'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Start the timer when the button is pressed
//                 },
//                 icon: const Icon(Icons.refresh, color: MyColor.grey),
//                 label: textCustom(text: 'reset'),
//               ),
//             ],
//           ),
