import 'package:bingo_game/page/game/right/ball_view/game.ball_created.dart';
import 'package:bingo_game/page/game/right/ball_view/game.ball_recent.dart';
import 'package:bingo_game/page/game/right/export.dart';

class GameDisplay extends StatelessWidget {
  final double height;
  final double width;
  const GameDisplay({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(StringFactory.padding24),
          decoration:  const BoxDecoration(
           border:  Border(
            left: BorderSide(width: 2.0, color: MyColor.grey_tab),
            right: BorderSide(width: 2.0, color: MyColor.grey_tab),
            bottom: BorderSide(width: 2.0, color: MyColor.grey_tab),
           ),
           borderRadius: 
            BorderRadius.only(
            topLeft: Radius.circular(StringFactory.padding84),
            topRight: Radius.circular(StringFactory.padding84),
            bottomLeft: Radius.circular(StringFactory.padding42),
            bottomRight: Radius.circular(StringFactory.padding42),
          ),
           
          ),
          child:  const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RecentBallPage(
                padding: StringFactory.padding16,
                margin: StringFactory.padding0,
              ),
              BallCreatedPage(
                padding: StringFactory.padding24,
                margin: StringFactory.padding16,
              ),
            ],
          )),
    );
  }
}
