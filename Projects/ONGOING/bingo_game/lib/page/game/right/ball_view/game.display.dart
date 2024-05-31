import 'package:bingo_game/page/game/right/ball_view/game.ball_created.dart';
import 'package:bingo_game/page/game/right/ball_view/game.ball_recent.dart';
import 'package:flutter/material.dart';

class GameDisplay extends StatelessWidget {
  final double height;
  final double width;
  const GameDisplay({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
         
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RecentBallPage(),
            BallCreatedPage(),
          ],
        ));
  }
}
