import 'package:bingo_game/model/ball.dart';
import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BallCreatedPage extends StatefulWidget {
  const BallCreatedPage({super.key});

  @override
  State<BallCreatedPage> createState() => _BallCreatedPageState();
}

class _BallCreatedPageState extends State<BallCreatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: ConfigFactory.delay_animation),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  void _triggerAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Ball> ballsGenerate = List.generate(
      ConfigFactory.LIST_LENGTH,
      (index) => Ball(
        id: index,
        number: index + 1,
        tag: ConfigFactory.tag_grey,
        isCreated: false,
        status: 'default',
      ),
    );

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: StringFactory.padding24,
          vertical: StringFactory.padding24),
      margin: const EdgeInsets.symmetric(horizontal: StringFactory.padding24),
      alignment: Alignment.topCenter,
      width: ConfigFactory.ratio_width_parent(width: width),
      height: ConfigFactory.ratio_height_parent(height: height) * 6.5 / 10,
      // color: MyColor.grey_tab,
      child: BlocListener<BallBloc, BallState>(
        listener: (context, state) {
          if (state is BallsLoaded) {
            _triggerAnimation();
          }
        },
        child: BlocBuilder<BallBloc, BallState>(
          builder: (context, state) {
            if (state is BallLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BallsLoaded) {
              return GridView.builder(
                itemCount: ballsGenerate.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ConfigFactory.LIST_ITEM_CROSS_COUNT,
                ),
                itemBuilder: (context, index) {
                  final ball = ballsGenerate[index];
                  final isBallPresent = state.balls.any((b) => b.number == ball.number);
                  Color color;
                  if (isBallPresent) {
                    final matchingBall = state.balls.firstWhere((b) => b.number == ball.number);
                    switch (matchingBall.tag) {
                      case ConfigFactory.tag_green:
                        color = MyColor.green;
                        break;
                      case ConfigFactory.tag_blue:
                        color = MyColor.blue_fb;
                        break;
                      case ConfigFactory.tag_yellow:
                        color = MyColor.yellow;
                        break;
                      case ConfigFactory.tag_purple:
                        color = MyColor.purple;
                        break;
                      case ConfigFactory.tag_red:
                        color = MyColor.red;
                        break;
                      default:
                        color = MyColor.green;
                        break;
                    }
                  } else {
                    color = MyColor.grey;
                  }
                  
                  return textCustomNormalColor(
                    color: color,
                    text: ball.number.toString(),
                    size: StringFactory.padding26,
                    fontWeight: FontWeight.bold,
                  );
                },
              );
            } else if (state is BallError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No balls'));
            }
          },
        ),
      ),
    );
  }
}
