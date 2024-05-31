import 'package:bingo_game/page/game/bloc/ball/ball_bloc.dart';
import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/image.asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameGenBall extends StatefulWidget {
  final double width;
  final double height;
  const GameGenBall({super.key, required this.width, required this.height});

  @override
  State<GameGenBall> createState() => _GameGenBallState();
}

class _GameGenBallState extends State<GameGenBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _translationAnimation;

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

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _translationAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from left
      end: const Offset(0.0, 0.0), // End at original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    return Container(
      padding: const EdgeInsets.all(StringFactory.padding24),
      width: ConfigFactory.area_ball_gen(width: widget.width, height: widget.height).first,
      height: ConfigFactory.area_ball_gen(width: widget.width, height: widget.height) .last,
      decoration: BoxDecoration(
          color: MyColor.black_absulute,
          borderRadius: BorderRadius.circular(ConfigFactory.borderRadiusCard)),
      child: BlocListener<BallBloc, BallState>(
        listener: (context, state) {
          if (state is BallsLoaded) {
            _triggerAnimation();
          }
        },
        child: BlocBuilder<BallBloc, BallState>(builder: (context, state) {
          if (state is BallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BallsLoaded) {
            return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: imageAsset(
                        isSmall: false,
                        tag: state.latestBall.tag,
                        text: '${state.latestBall.number}',
                        width: ConfigFactory.area_ball_gen(
                                width: widget.width, height: widget.height)
                            .first,
                        height: ConfigFactory.area_ball_gen(
                                width: widget.width, height: widget.height)
                            .last,
                      ),
                    ),
                  );
                });
          } else if (state is BallError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No balls'));
          }
        }),
      ),
    );
  }
}
