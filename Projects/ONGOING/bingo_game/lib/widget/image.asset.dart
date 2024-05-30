import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget imageAsset({required double width, required double height,required String tag,required String text}
) {
  String assetPath;
  // Switch case to select assetPath based on tag
  switch (tag) {
    case ConfigFactory.tag_blue:
      assetPath = ConfigFactory.BALL_BLUE;
      break;
    case ConfigFactory.tag_green:
      assetPath = ConfigFactory.BALL_GREEN;
      break;
    case ConfigFactory.tag_purple:
      assetPath = ConfigFactory.BALL_PURPLE;
      break;
    case ConfigFactory.tag_red:
      assetPath = ConfigFactory.BALL_RED;
      break;
    case ConfigFactory.tag_yellow:
      assetPath = ConfigFactory.BALL_YELLOW;
      break;
    default: assetPath = ConfigFactory.BALL_GREEN;
  }
  return Stack(
    alignment: Alignment.center,
    children: [
      Image.asset(
        assetPath,
        fit: BoxFit.contain,
        width: width,
        height: height,
      ),
      textCustomStyle(text: text, size: StringFactory.padding48, fontWeight: FontWeight.bold)
    ],
  );
}

Widget imageAssetSmall(
  assetPath,
) {
  return Wrap(
    children: [
      Image.asset(
        '$assetPath',
        fit: BoxFit.contain,
        width: 25.0,
        height: 25.0,
      ),
    ],
  );
}
