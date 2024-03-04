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
    smallText =false,
    smallAsset =false,
    hasAsset =true,
    isTextBold =false,
    smallBorder =false,
    hasWidthAssetDiff,
    isActive =false,
    width,
    paddingVer = PaddingD.padding16,
    spacingHor = PaddingD.padding32}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(smallBorder==true ? MyWidths.width_borderRadiusSmall : MyWidths.width_borderRadius),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: MyColor.bedgeLight,
        onTap: onTap,
        child: Container(
          width: hasWidth == true ? width : null,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: PaddingD.padding32, vertical: paddingVer),
          decoration: BoxDecoration(
            border: Border.all(color:isActive?MyColor.green : Colors.transparent),
            color:isActive? MyColor.white :  MyColor.bedgeLight.withOpacity(.75),
            borderRadius: BorderRadius.circular(smallBorder==true ? MyWidths.width_borderRadiusSmall : MyWidths.width_borderRadius),
          ),
          child: customRow(isCenter: true, children: [
            hasAsset==true? customImageAsset(
              width:smallAsset ==true ? MyWidths.width_asset_small :  hasWidthAssetDiff!=null?MyWidths.width_asset*.8 : MyWidths.width_asset,
              path: pathAsset,
            ):Container(),
            hasAsset==true ?  SizedBox(
              width: spacingHor,
            ) : Container(),
            text_custom(text: text, size: smallText==true?TextSize.text20    :  TextSize.text42,weight: isActive ? FontWeight.bold :FontWeight.normal,color:isActive?MyColor.black_text:MyColor.grey)
          ]),
        ),
      ),
    ),
  );
}
