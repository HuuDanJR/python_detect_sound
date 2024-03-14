import 'package:flutter/material.dart';
import 'package:toilet_client/animation/background_animation.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

Widget tempItem({height, width, tempurature, humid}) {
  const double assetSize = 55.0;
  return SizedBox(
    width: width,
    height: height * 3 / 5,
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: width,
          height: (height * 3 / 5) / 2,
          decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(width / 2),
                topRight: Radius.circular(width / 2),
              ),
              border: Border.all(color: MyColor.yellowBG, width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/tempurature.png',
                width: assetSize,
                height: assetSize,
              ),
              text_custom(
                  text: '$tempurature°',
                  size: TextSizeDefault.text42,
                  weight: FontWeight.w700,
                  color: MyColor.yellowBG),
            ],
          ),
        ),
        Container(
          width: width,
          height: (height * 3 / 5) / 2,
          decoration: BoxDecoration(
              color: MyColor.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(width / 2),
                bottomRight: Radius.circular(width / 2),
              ),
              border: Border.all(color: MyColor.yellowBG, width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/humid.png',
                width: assetSize,
                height: assetSize,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text_custom(
                      text: '$humid',
                      size: TextSizeDefault.text48,
                      weight: FontWeight.w700,
                      color: MyColor.greenBG),
                  text_custom(
                    text: '%',
                    size: 24,
                    weight: FontWeight.w700,
                    color: MyColor.greenBG,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget mainItem(
    {width,
    height,
    width_item,
    height_item,
    padding_item,
    isUseMen1,
    isUseMen2,
    isUseWoman1}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // AnimatedGradient(
      //   width: width / 2,
      //   height: height * 4 / 5,
      //   colorList: const [
      //     MyColor.blueBG,
      //     MyColor.blueBG2,
      //     MyColor.blueBG3,
      //     MyColor.blueBG4,
      //     MyColor.blueBG5,
      //   ],
      //   widget:
      Container(
        width:width/2,
        color:MyColor.blueBG,
        child:
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/man.png',
              width: width_item,
              height: height_item,
            ),
            SizedBox(
              height: padding_item * 1.5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                toiletItem(isUsed: isUseMen1),
                SizedBox(
                  width: padding_item,
                ),
                toiletItem(isUsed: isUseMen2),
              ],
            )
          ],
        ),
        // ),
      ),
      // AnimatedGradient(
      //   width: width / 2,
      //   height: height * 4 / 5,
      //   colorList: const [
      //     MyColor.pinkBG,
      //     MyColor.pinkBG2,
      //     MyColor.pinkBG3,
      //     MyColor.pinkBG4,
      //     MyColor.pinkBG5,
         
       
      //   ],
      //   widget:
      Container(
        width: width/2,
        color:MyColor.pinkBG3,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/woman.png',
              width: width_item,
              height: height_item,
            ),
            SizedBox(
              height: padding_item * 2,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                toiletItem(isUsed: isUseWoman1),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

Widget toiletItem({isUsed}) {
  return Column(
    children: [
      SizedBox(
        // height: 125.0,
        // width: 125.0,
        height: 145.0,
        width: 145.0,
        child: Container(
          child: Stack(
            children: [
              Positioned(
                  right: PaddingDefault.padding24,
                  top: PaddingDefault.pading08,
                  child: Image.asset(
                      isUsed == null
                          ? 'assets/information.png'
                          : isUsed == false
                              ? 'assets/check.png'
                              : "assets/check2.png",
                      width: 42.5,
                      height: 42.5)),
              Image.asset(isUsed == false
                  ? 'assets/toilet.png'
                  : "assets/toilet_grey.png"),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: PaddingDefault.pading08,
      ),
      text_custom(
          text: isUsed == false ? 'VACANT' : 'OCCUPIED',
          color: MyColor.black_text,
          size: TextSizeDefault.text24,
          weight: FontWeight.w500),
    ],
  );
}
