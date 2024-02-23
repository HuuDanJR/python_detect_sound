import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/widget/custom_text.dart';


Widget buttonClose() {
  return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: PaddingD.padding24,
          vertical: PaddingD.pading08),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(PaddingD.padding32),
          bottomLeft: Radius.circular(PaddingD.padding32),
        ),
        color: MyColor.red,
      ),
      child: text_custom(
          text: "CLOSE",
          color: MyColor.white,
          weight: FontWeight.bold,
          size: TextSize.text16));
}
