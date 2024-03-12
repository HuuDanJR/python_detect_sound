import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget customSliderData({width, height, String? text, onChange, onClose}) {
  return GetBuilder<MyGetXController>(
    builder: (controller) => customColumn(
      isTop: true,
      children: [
        text_custom(
            text: '${controller.valueSlider.value.round()}',
            size: TextSize.text28,
            weight: FontWeight.normal),
        const SizedBox(
          height: PaddingD.pading08,
        ),
        Container(
          width: MyWidths.slider_item_width,
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
                    activeColor: controller.valueSlider.value.round() >= 130
                        ? MyColor.red
                        : controller.valueSlider.value.round() >= 85
                            ? Colors.orange
                            : MyColor.green_slider,
                    allowedInteraction: SliderInteraction.tapAndSlide,
                    value: controller.valueSlider.value,
                    min: 0,
                    max: 180,
                    onChanged: (value) {
                      onChange(value);
                    },
                  ))),
        ),
        const SizedBox(
          height: PaddingD.padding16,
        ),
        customImageAsset(
            path: controller.valueSlider.value != 0
                ? MyAssets.volumn_on
                : MyAssets.volumn_off,
            width: MyWidths.slider_image_asset),
        const SizedBox(
          height: PaddingD.pading08,
        ),
        text_custom(
            text: text!.toUpperCase(),
            size: TextSize.text22,
            weight: FontWeight.bold),
            const Divider(),
        TextButton(
            onPressed: onClose,
            child: text_custom(
                text: "CLOSE",
                size: TextSize.text22,
                color: MyColor.red_accent,
                weight: FontWeight.bold))
      ],
    ),
  );
}

Widget customSliderFit({required double item_width, height, String? text, onChange, onClose,required isTextNormal}) {
  return GetBuilder<MyGetXController>(builder: (controller) =>
    customColumn(
    isTop: true,
    children: [
      text_custom(
          // text: '100',
          text: '${controller.valueSliderAll.value.round()}',
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
                  activeColor: controller.valueSliderAll.value.round() >= 130
                      ? MyColor.red
                      : controller.valueSliderAll.value.round() >= 85
                          ? Colors.orange
                          : MyColor.green_slider,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  value: controller.valueSliderAll.value,
                  min: 0,
                  max: 180,
                  onChanged: (value) {
                    onChange(value);
                  },
                ))),
      ),
      const SizedBox(
        height: PaddingD.pading08,
      ),
     
      customImageAsset(
          path: controller.valueSliderAll.value != 0
              ? MyAssets.volumn_on
              : MyAssets.volumn_off,
          width: MyWidths.slider_image_asset),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      Container(
        alignment: Alignment.center,
        width: item_width*2,
        child: text_custom_center(
            text: text!.toUpperCase(),
            size: TextSize.text16,
            weight:isTextNormal==false? FontWeight.bold:FontWeight.normal),
      ),
    ],
  )
  );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    @required RenderBox? parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme!.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox!.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
