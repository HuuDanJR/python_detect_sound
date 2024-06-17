import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/model/ball.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/widget/text.custom.dart';

class BallCreatedPage extends StatefulWidget {
  final double padding;
  final double margin;
  const BallCreatedPage(
      {super.key, required this.padding, required this.margin});

  @override
  State<BallCreatedPage> createState() => _BallCreatedPageState();
}

class _BallCreatedPageState extends State<BallCreatedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int totalListLength = ConfigFactory.LIST_LENGTH;
  late Animation<double> _fadeAnimation;
  List<Ball> ballsGenerate = [];
  List<Ball> generateBall(List<int> numbers) {
    for (int i = 0; i < numbers.length; i++) {
      Ball ball = Ball(
        id: i + 1, // Assuming id starts from 1
        number: numbers[i],
        tag: determineTag(numbers[i]), // Determine tag based on number
        isCreated: true, // Assuming all balls are created initially
        status: 'added', // Initial status
      );
      ballsGenerate.add(ball);
    }
    return ballsGenerate;
  }

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
    HiveController().getSetting().then((value) {
      if (value != null || value!.roundInitial.isNotEmpty) {
        context.read<BallBloc>().add(InitializeBalls(initialBalls: generateBall(value.roundInitial)));
        setState(() {
          totalListLength = value.totalRound;
        });
      } else {
        context.read<BallBloc>().add(InitializeBalls(initialBalls: ballsGenerate));
      }
    });
    // Trigger the InitializeBalls event
    // context.read<BallBloc>().add(InitializeBalls(initialBalls: ballsGenerate));
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
    final List<Ball> ballsGenerateList = List.generate(
      totalListLength,
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
      padding: EdgeInsets.symmetric(
          horizontal: widget.padding, vertical: widget.padding),
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      alignment: Alignment.topCenter,
      width: ConfigFactory.ratio_width_parent(width: width),
      height:
          ((ConfigFactory.ratio_height_parent(height: height) * 6.85) / 10) -
              StringFactory.padding56,
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
                itemCount: ballsGenerateList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ConfigFactory.LIST_ITEM_CROSS_COUNT,
                ),
                itemBuilder: (context, index) {
                  final ball = ballsGenerateList[index];
                  final isBallPresent =  state.balls.any((b) => b.number == ball.number);
                  Color color;
                  if (isBallPresent) {
                    final matchingBall =state.balls.firstWhere((b) => b.number == ball.number);
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



 // Ball(id: 1, number: 1, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 2, number: 2, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 3, number: 3, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 4, number: 4, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 5, number: 5, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 6, number: 6, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 7, number: 7, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 8, number: 8, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 9, number: 9, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 10, number: 10, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 11, number: 11, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 12, number: 12, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 13, number: 13, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 10, number: 10, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 14, number: 14, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 15, number: 15, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 16, number: 16, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 17, number: 17, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 18, number: 18, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 19, number: 19, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),
    // Ball(id: 20, number: 20, tag: ConfigFactory.tag_yellow, isCreated: true, status: 'added'),