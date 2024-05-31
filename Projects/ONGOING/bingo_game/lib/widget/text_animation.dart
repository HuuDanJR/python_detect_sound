import 'package:bingo_game/page/game/right/export.dart';

Widget TextAnimationWidget({
  required Color? color,
  required String? text,
  required double? size,
  required FontWeight? fontWeight,
  required double? animatedOpacity,
  required double? animatedScale,
}) {
  return Opacity(
    opacity: animatedOpacity!,
    child: Transform.scale(
      scale: animatedScale, // Adjust as needed
      child: Text(
        text!,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}