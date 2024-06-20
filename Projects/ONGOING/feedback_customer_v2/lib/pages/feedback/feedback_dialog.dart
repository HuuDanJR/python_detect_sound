import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';

Widget feedbackDialog({required double width, required double height}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color:MyColor.white,
      borderRadius: BorderRadius.circular(StringFactory.padding32),
    ),
    child: textCustomCenter(
      text: title_dialog_feedback,
      size: StringFactory.padding26
    ),
  );
}
