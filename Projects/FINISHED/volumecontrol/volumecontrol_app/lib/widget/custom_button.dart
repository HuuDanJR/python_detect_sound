import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget custom_button(
    {onTap,
    pathAsset,
    text,
    width,
    paddingVer = PaddingD.padding16,
    spacingHor = PaddingD.padding32}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular( MyWidths.width_borderRadiusSmall),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: MyColor.bedgeLight,
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: PaddingD.padding32, vertical: paddingVer),
          decoration: BoxDecoration(
            color: MyColor.white,
            border: Border.all(color:MyColor.blue),
            borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall ),
          ),
          child: customRow(isCenter: true, children: [
             customImageAsset(
              width: MyWidths.width_asset_button,
              path: pathAsset,
            ),
            SizedBox(
              width: spacingHor,
            ),
            text_custom(text: text, size: TextSize.text20,weight: FontWeight.normal )
          ]),
        ),
      ),
    ),
  );
}
