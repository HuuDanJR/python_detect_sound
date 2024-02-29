import 'package:flutter/material.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget volumeImageAsset({
  name,
  path,
  width,
  top,left,onTap,
}) {
  return Positioned(
    top: top,
    left: left,
    child: GestureDetector(
      onTap: onTap,
      child: customColumn(children: 
      [
        customImageAsset(path: MyAssets.volume, width: MyWidths.width_asset_smalest),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: PaddingD.pading12,vertical: 0.0),
          decoration: BoxDecoration(
            color:MyColor.white,
            border: Border.all(color:MyColor.black_text),
            borderRadius: BorderRadius.circular(PaddingD.pading08)
          ),
          child: text_custom(text: name,weight: FontWeight.bold,color: MyColor.orange_accent,size: TextSize.text14),
        )
        // text_custom(text: name,weight: FontWeight.bold,color: MyColor.orange_accent,size: TextSize.text16),
      ])
    ),
  );
}
