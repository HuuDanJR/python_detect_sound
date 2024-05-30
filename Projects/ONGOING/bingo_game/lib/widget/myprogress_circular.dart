import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/image.asset.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';


Widget myprogress_circular(){
	return const Center(
                    child: CircularProgressIndicator(
                    color: MyColor.grey,
                    strokeWidth: 1,
                    backgroundColor: MyColor.grey_tab,
                  ));
}



Widget myprogress_circular_icon() {
  return Center(
    child: Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(StringFactory.padding),
          decoration: BoxDecoration(
            color:MyColor.white,
            border: Border.all(color:MyColor.grey_tab),
            borderRadius: BorderRadius.circular(StringFactory.padding16)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),const SizedBox(width: StringFactory.padding,),
              imageAssetSmall('assets/icons/point.png'),
              textCustom2(text: "Loading, Please wait for a moment",size: 14),
            ],
          ),
        ),
      ],
    ),
  );
}