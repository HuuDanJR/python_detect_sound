import 'package:bingo_game/page/game/left/game.playauto.dart';
import 'package:bingo_game/page/game/left/game.image.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/config.dart';
import 'package:flutter/material.dart';

class GameLeftPage extends StatelessWidget {
  const GameLeftPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      width: ConfigFactory.ratio_width_child(width: width),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: MyColor.grey_tab),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameImagePage( width: ConfigFactory.ratio_width_child(width: width),height: ConfigFactory.ratio_height_child(height: height)),
          GamePlayAuto(width: ConfigFactory.ratio_width_child(width: width), height: ConfigFactory.ratio_height_parent(height: height)),
        ],
      ),
    );
  }
}
