import 'package:flutter/material.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/widget/button_custom.dart';

Widget starLineItem({int? index, bool? isActive = false, onPress}) {
  return customPressButton(
      padding: 72,
      onPress: () {
        // print('choose $index');
        onPress();
      },
      child: Icon(Icons.star,
          color: isActive == false ? MyColor.greyBG : MyColor.yellowBG,
          size: 88));
}


Widget starLineItemSmall({int? index, bool? isActive = false, onPress,size}) {
  return customPressButton(
      padding: size,
      onPress: () {
        // print('choose $index');
        onPress();
      },
      child: Icon(Icons.star,
          color: isActive == false ? MyColor.greyBG : MyColor.yellowBG,
          size: size));
}

