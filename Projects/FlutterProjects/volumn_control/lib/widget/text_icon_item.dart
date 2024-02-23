import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget text_icon_item(
    {onTap,
    pathAsset,
    text,
    hasWidth = false,
    hasWidthAssetDiff,
    width,
    paddingVer = PaddingD.padding16,
    spacingHor = PaddingD.padding32}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(MyWidths.width_borderRadius),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: MyColor.bedgeLight,
        onTap: () {
          onTap();
        },
        child: Container(
          width: hasWidth == true ? width : null,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: PaddingD.padding32, vertical: paddingVer),
          decoration: BoxDecoration(
            color: MyColor.bedgeLight.withOpacity(.75),
            borderRadius: BorderRadius.circular(MyWidths.width_borderRadius),
          ),
          child: customRow(isCenter: true, children: [
            customImageAsset(
              width:hasWidthAssetDiff!=null?MyWidths.width_asset*.8 : MyWidths.width_asset,
              path: pathAsset,
            ),
            SizedBox(
              width: spacingHor,
            ),
            text_custom(text: text, size: TextSize.text42)
          ]),
        ),
      ),
    ),
  );
}
