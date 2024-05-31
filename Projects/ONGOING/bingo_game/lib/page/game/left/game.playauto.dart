import 'package:bingo_game/page/game/left/game.genball.dart';
import 'package:bingo_game/page/game/left/game.timer.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';

class GamePlayAuto extends StatelessWidget {
  final double height;
  final double width;
  const GamePlayAuto({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             GameGenBall(
              width: width,
              height: height,
            ),
            const SizedBox(
              height: StringFactory.padding12,
            ),
            textCustomStyle(
                text: 'CURRENT CALL',
                size: StringFactory.padding28,
                fontWeight: FontWeight.bold),
            const SizedBox(
              height: StringFactory.padding32,
            ),
            textCustomStyle(
                text: 'NEXT CALL',
                size: StringFactory.padding20,
                fontWeight: FontWeight.w500),
            // textCustomStyle(text: '04:35',size: StringFactory.padding20,fontWeight: FontWeight.bold),
            const GameTimerPage()
          ],
        ),
      ),
    );
  }
}
