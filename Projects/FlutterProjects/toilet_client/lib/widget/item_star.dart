import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/widget/star.dart';

Widget rowStar({controllerGetx,onPress}) {
  return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          starLineItem(
              index: 1,
              isActive: controllerGetx.star1.value,
              onPress: () {
                controllerGetx.changeStarState(1);
                onPress();
              }),
          const SizedBox(
            width: 8.0,
          ),
          starLineItem(
              index: 2,
              isActive: controllerGetx.star2.value,
              onPress: () {
                controllerGetx.changeStarState(2);
                onPress();
              }),
          const SizedBox(
            width: 8.0,
          ),
          starLineItem(
              index: 3,
              isActive: controllerGetx.star3.value,
              onPress: () {
                controllerGetx.changeStarState(3);
                onPress();
              }),
          const SizedBox(
            width: 8.0,
          ),
          starLineItem(
              index: 4,
              isActive: controllerGetx.star4.value,
              onPress: () {
                controllerGetx.changeStarState(4);
                onPress();
              }),
          const SizedBox(
            width: 8.0,
          ),
          starLineItem(
              index: 5,
              isActive: controllerGetx.star5.value,
              onPress: () {
                controllerGetx.changeStarState(5);
                onPress();
              }),
        ],
      ));
}




Widget rowStarDisplay({onPress,input,size}) {
  return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:List.generate(
      5,
      (index) => starLineItemSmall(
        size:size,
        index: index + 1,
        isActive: index < input,
        onPress: onPress,
      ),
    ),
      );
}
