import 'package:bingo_game/page/game/left/export.dart';

class RecentBallBody extends StatefulWidget {
  final double itemWidth;
  final double itemHeight;
  const RecentBallBody({super.key, required this.itemWidth, required this.itemHeight});

  @override
  State<RecentBallBody> createState() => _RecentBallBodyState();
}

class _RecentBallBodyState extends State<RecentBallBody> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _translationAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:   const Duration(seconds: ConfigFactory.delay_animation),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
     _translationAnimation = Tween<Offset>(
      begin: const Offset(-50.0, 100.0), // Start from left
      end: const Offset(0.0, 0.0), // End at original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Delay the start of the animation by 2 seconds
    Future.delayed(const Duration(seconds: ConfigFactory.delay_animation), () {
      _controller.forward();
    });
  }

  void _triggerAnimation() {
    _controller.reset();
    Future.delayed(const Duration(seconds: ConfigFactory.delay_animation), () {
      _controller.forward();
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<BallBloc,BallState>(
      listener: (context, state) {
          if (state is BallsLoaded) {
            _triggerAnimation();
          }
        },
      child: BlocBuilder<BallBloc, BallState>(
        builder: (BuildContext context, BallState state) {
          if (state is BallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BallsLoaded) {
            final reversedBalls = state.balls.reversed.take(5).toList();
            return Center(
              child: GridView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: reversedBalls.length,
                itemBuilder: (context, index) {
                  final ball = reversedBalls[index];
                  if (index == 0) {
                    // Apply animation for the first item only
                  return 
                    AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: _translationAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: imageAsset(
                              isSmall: true,
                              tag: ball.tag,
                              text: '${ball.number}',
                              width: ConfigFactory.area_ball_gen_small(width: widget.itemWidth, height: widget.itemHeight).first,
                              height: ConfigFactory.area_ball_gen_small(width: widget.itemWidth, height: widget.itemHeight).last,
                            ),
                          ),
                        ),
                      );
                    });
                  } else {
                    return imageAsset(
                      tag: ball.tag,
                      isSmall: true,
                      text: '${ball.number}',
                      width: ConfigFactory.area_ball_gen_small(width: widget.itemWidth, height: widget.itemHeight).first,
                      height: ConfigFactory.area_ball_gen_small(width: widget.itemWidth, height: widget.itemHeight).last,
                    );
                  }
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: StringFactory.padding,
                  mainAxisSpacing: StringFactory.padding
                ),
              ),
            );
          } else if (state is BallError) {
            return Center(child: Text('Error balls :${state.message}'));
          } else {
            return const Center(child: Text('No balls'));
          }
        },
      ),
    );
  }
}
