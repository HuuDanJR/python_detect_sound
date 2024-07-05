import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/image_asset_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';

Widget suggestionItem(
    {required double width,
    required double height,
    required double scale,
    required String text,
    required Function onPressed,
    required String assetPath}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(StringFactory.padding56),
    child: Material(
      color: MyColor.background,
      child: InkWell(
        onTap:(){
          onPressed();
        },
        splashColor: MyColor.grey_tab,
        child: Container(
            padding: const EdgeInsets.all(StringFactory.padding28),
            decoration: BoxDecoration(
              color: MyColor.background,
              borderRadius: BorderRadius.circular(StringFactory.padding56),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width:width,
                  height:height,
                  child: customImageAsset(
                    scale: scale,
                    width: width,
                    height: height,
                    image: assetPath,
                  ),
                ),
                textCustomMedium(text: text, size: StringFactory.padding32)
              ],
            )),
      ),
    ),
  );
}
