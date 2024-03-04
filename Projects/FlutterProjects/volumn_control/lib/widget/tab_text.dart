import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget tab_text(
    {onTap,
    text,
    width,
    isActive,
    }) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashColor: MyColor.bedgeLight,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: PaddingD.padding16, vertical: PaddingD.padding0),
        decoration: BoxDecoration(
          color:isActive? MyColor.white :  MyColor.grey_tab,
          border: Border.all( color:isActive ? MyColor.green : Colors.transparent),
          borderRadius: BorderRadius.circular( MyWidths.width_borderRadiusMinial),
        ),
        child: text_custom(color:isActive?MyColor.black_text:MyColor.grey, text: text, size: TextSize.text20 ,weight: isActive?FontWeight.w600 :FontWeight.normal )),
      ),
    );
}
