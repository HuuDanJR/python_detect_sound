import 'package:flutter/material.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

Widget buttonClose() {
  return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: PaddingDefault.padding24,
          vertical: PaddingDefault.pading08),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(PaddingDefault.padding32),
          bottomLeft: Radius.circular(PaddingDefault.padding32),
        ),
        color: MyColor.red,
      ),
      child: text_custom(
          text: "CLOSE",
          color: MyColor.white,
          weight: FontWeight.bold,
          size: TextSizeDefault.text16));
}
