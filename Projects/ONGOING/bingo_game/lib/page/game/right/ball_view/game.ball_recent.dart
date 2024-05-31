import 'package:bingo_game/page/game/right/ball_view/game.ball_recent_body.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecentBallPage extends StatelessWidget {
  const RecentBallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final itemWidth = ConfigFactory.ratio_width_parent(width: width);
    final itemHeight =
        ConfigFactory.ratio_height_parent(height: height) * 3.5 / 10;
    return Container(
        alignment: Alignment.center,
        width: itemWidth,
        height: itemHeight,
        padding:
            const EdgeInsets.symmetric(horizontal: StringFactory.padding24),
        margin: const EdgeInsets.symmetric(horizontal: StringFactory.padding24),
        decoration: BoxDecoration(
            color: MyColor.black_absulute,
            borderRadius: BorderRadius.circular(StringFactory.padding56)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RecentBallBody(
              itemHeight: itemHeight,
              itemWidth: itemWidth,
            ),
            textCustomNormalColor(
                text: 'PREVIOUS 5 CALLS',
                color: MyColor.white,
                size: StringFactory.padding20,
                fontWeight: FontWeight.bold)
          ],
        ));
  }
}
