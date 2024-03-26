import 'package:flutter/material.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget customSliderFitNoData(
    {required double item_width,
    height,
    String? text,
    onChange,
    onClose,
    required double currentValue,
    required isTextNormal}) {
  return customColumn(
    isTop: true,
    children: [
      text_custom(
          text: '${currentValue.round()}',
          size: TextSize.text22,
          weight: FontWeight.normal),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      Container(
        width: item_width,
        padding: const EdgeInsets.only(
            top: PaddingD.padding16, bottom: PaddingD.padding04),
        height: height,
        decoration: BoxDecoration(
            color: MyColor.black_text,
            borderRadius: BorderRadius.circular(PaddingD.padding32)),
        child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
                data: SliderThemeData(
                  tickMarkShape: SliderTickMarkShape.noTickMark,
                  trackHeight: MyWidths.slider_item_width_small,
                  trackShape: CustomTrackShape(),
                  valueIndicatorShape: SliderComponentShape.noOverlay,
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorColor: MyColor.bedge,
                ),
                child: Slider(
                  inactiveColor: Colors.transparent,
                  activeColor: currentValue >= 130
                      ? MyColor.red
                      : currentValue >= 85
                          ? Colors.orange
                          : MyColor.green_slider,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  value: currentValue,
                  min: 0,
                  max: MyWidths.SLIDER_MAX_VALUE,
                  onChanged: (value) {
                    onChange(value);
                  },
                ))),
      ),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      customImageAsset(
          path: currentValue != 0
              ? MyAssets.volumn_on
              : MyAssets.volumn_off,
          width: MyWidths.slider_image_asset),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      Container(
        alignment: Alignment.center,
        height: MyWidths.tab_item_height(height),
        width: item_width * 1.75,
        child: text_custom_center(
            text: text!.toUpperCase(),
            size: TextSize.text14,
            weight:isTextNormal == false ? FontWeight.bold : FontWeight.normal),
      ),
    ],
  );
}


