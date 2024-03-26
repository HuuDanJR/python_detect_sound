import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget textContainer({required String text,required bool isBool,required bool hasFocus ,required int type}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: PaddingD.pading12, vertical: 0.0),
    decoration: BoxDecoration(
        color:hasFocus==true?  MyColor.green_araconda : type == 0? MyColor.coral: MyColor.orangeSafe,
        // color:hasFocus==true?  MyColor.greenOpa : MyColor.blueBG_opa,
        border: Border.all(color: MyColor.white),
        borderRadius: BorderRadius.circular(PaddingD.padding04)),
    child: text_custom(
        text: text,
        weight: FontWeight.bold,
        color:  MyColor.black_text,
        size: TextSize.text16),
  );
}
