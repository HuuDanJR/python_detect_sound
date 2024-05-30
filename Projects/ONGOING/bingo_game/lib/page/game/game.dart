import 'package:bingo_game/page/game/left/game.left.dart';
import 'package:bingo_game/page/game/right/game.right.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Row(
          children: [
            GameLeftPage(),
            GameRightPage(),
          ],
        ),
      ),
    );
  }
}
