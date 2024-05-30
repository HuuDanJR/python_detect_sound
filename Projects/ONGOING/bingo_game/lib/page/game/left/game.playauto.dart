import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:bingo_game/page/game/left/game.timer.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/image.asset.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Container(
              padding: const EdgeInsets.all(StringFactory.padding24),
              width: ConfigFactory.area_ball_gen(width: width, height: height).first,
              height: ConfigFactory.area_ball_gen(width: width, height: height).last,
              decoration: BoxDecoration(
                  color: MyColor.black_absulute,
                  borderRadius:BorderRadius.circular(ConfigFactory.borderRadiusCard)),
              child:BlocBuilder<BallBloc, BallState>(builder: (context, state) {
                if (state is BallLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BallLoaded) {
                  return imageAsset(
                      tag: state.ball.tag,
                      text: '${state.ball.number}',
                      width: ConfigFactory.area_ball_gen(
                              width: width, height: height) .first,
                      height: ConfigFactory.area_ball_gen(
                              width: width, height: height) .last);
                } else if (state is BallError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No balls'));
                }
              }),
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
