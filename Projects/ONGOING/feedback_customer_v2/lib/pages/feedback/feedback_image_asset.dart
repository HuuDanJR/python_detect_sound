import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget imageAsset({
  required orientation,
  required int index,
}) {
  return GetBuilder<MyGetXController>(
    builder: (controller) {
      return Padding(
    padding: EdgeInsets.all(orientation == Orientation.portrait
        ? StringFactory.padding24
        : StringFactory.padding12),
    child: Image.asset(
      fit: BoxFit.contain,
      scale: 1,
      controller.list_feedback[index].isSelected == false
          ? controller.list_feedback[index].image
          : controller.list_feedback[index].imageUnSelected,
      filterQuality: FilterQuality.low,
      alignment: Alignment.center,
    ),
  );
    },
  );
  
}
