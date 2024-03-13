import 'package:flutter/material.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/public/deboucer.dart';
import 'package:volumn_control/public/loader_dialog.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/alert_dialog.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_text.dart';

class CustomSliderPage extends StatefulWidget {
  CustomSliderPage(
      {super.key,
      required this.url,
      this.paddingLeft,
      required this.valueSlider,
      required this.item_width,
      required this.deviceName,
      required this.height,
      required this.id,
      this.isTextNormal,
      required this.text});
  double valueSlider;
  final String url;
  double? paddingLeft;
  final double item_width;
  final double height;
  final String text;
  final bool? isTextNormal;
  final String deviceName;
  final String id;

  @override
  State<CustomSliderPage> createState() => _CustomSliderPageState();
}

class _CustomSliderPageState extends State<CustomSliderPage>
    with AutomaticKeepAliveClientMixin {
  final serviceAPIs = MyAPIService();
  final debouncer =
      Debouncer(milliseconds: 1000, delay: const Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    super.build(context); //this line is needed
    return customColumn(isTop: true, children: [
      text_custom(
          text: '${widget.valueSlider.round()}',
          size: TextSize.text22,
          weight: FontWeight.normal),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      Container(
        margin: EdgeInsets.only(
          left: widget.paddingLeft ?? 0,
        ),
        width: widget.item_width,
        padding: const EdgeInsets.only(
            top: PaddingD.padding16, bottom: PaddingD.padding04),
        height: widget.height,
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
                  activeColor: widget.valueSlider.round() >= 130
                      ? MyColor.red
                      : widget.valueSlider.round() >= 85
                          ? Colors.orange
                          : MyColor.green_slider,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                  value: widget.valueSlider,
                  min: 0,
                  max: 180,
                  onChanged: (value) {
                    setState(() {
                      widget.valueSlider = value;
                    });
                    debouncer.run(() {
                      // showLoaderDialog(context);
                      debugPrint('value: ${widget.valueSlider}');
                      serviceAPIs
                          .runDeviceFullURL(
                              url: MyString.GET_DEVICE_API(
                                  deviceName: widget.deviceName,
                                  position: '${widget.valueSlider}'))
                          .then((value) {})
                          .whenComplete(() => null);
                      serviceAPIs
                          .updateVolumeValue(
                              id: widget.id, value: widget.valueSlider)
                          .then((value) {
                        // showCustomAlertDialog2Fun(
                        //     context: context,
                        //     textbutton: 'CONTINUE',
                        //     function: () {
                        //       debugPrint('click functionFinish');
                        //       Navigator.of(context).pop();
                        //       Navigator.of(context).pop();
                        //       setState(() {});
                        //     },
                        //     functionCancel: () {
                        //       debugPrint('click function cancel');
                        //       Navigator.of(context).pop();
                        //       Navigator.of(context).pop();
                        //       setState(() {});
                        //     },
                        //     text: '${value['message']}');
                      }).whenComplete(() {
                        // Navigator.of(context).pop();
                      });
                    });
                  },
                ))),
      ),
      const SizedBox(
        height: PaddingD.pading08,
      ),
      customImageAsset(
          path: widget.valueSlider != 0
              ? MyAssets.volumn_on
              : MyAssets.volumn_off,
          width: MyWidths.slider_image_asset),
      const SizedBox(
        height: PaddingD.padding04,
      ),
      Container(
        alignment: Alignment.center,
        width: widget.item_width * 1.35,
        child: text_custom_center(
            text: widget.text.toUpperCase(),
            size: TextSize.text16,
            weight: widget.isTextNormal == false
                ? FontWeight.bold
                : FontWeight.normal),
      ),
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
