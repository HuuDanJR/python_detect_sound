import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';

class GameBanner extends StatelessWidget {
  final double width;
  final double height;
  const GameBanner({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      width: width,
      height:height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
       border: Border(
          top: BorderSide(width: 1, color: MyColor.grey_tab),
        ),
      ),
      child: textCustom(text: 'banner area'),
    );
  }
}
