import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/widget/zone/zone_list.dart';
import 'package:volumn_control/page/widget/zone/zone_list_sync.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_button.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_switch.dart';
import 'package:volumn_control/widget/divider_vertical.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  late final bool _switchValue = false;
  final controllerGetX = Get.put(MyGetXController());
  final serviceAPIs = MyAPIService();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final itemWidthSlider = width / 11;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: PaddingD.padding24),
          // alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius:
                BorderRadius.circular(MyWidths.width_borderRadiusSmall),
          ),
          width: width,
          height: height,
          // child: text_custom(text:"zone")
          child: customRow(
            children: [
            SizedBox(
                width: itemWidthSlider,
                height: height,
                child: GetBuilder<MyGetXController>(
                  builder: (controller) => customSliderFit(
                      isTextNormal: true,
                      text: 'ALL',
                      item_width: MyWidths.slider_item_width,
                      height: MyWidths.height_slider(height),
                      onChange: (double value) {
                        if (controllerGetX.isSwitch == true) {
                          // serviceAPIs.updateVolumeValue()
                          controllerGetX.saveValueSliderAll(value);
                          controllerGetX.toggleHasChangeValueSlider();
                          print('customSliderFit ALL : ACTIVE => $value');
                        } else {
                          print('customSliderFit ALL : NOT ACTIVE');
                        }
                      }),
                )),
            Align(
              alignment: Alignment.center,
              child: dividerVer(height)),
            Expanded(
                child: SizedBox(
                    width: width - itemWidthSlider,
                    height: height,
                    child: Obx(() => controllerGetX.isSwitch.value == true
                        ?  zoneListSync(height: height, serviceAPIs: serviceAPIs,) 
                        : zoneList(height: height, serviceAPIs: serviceAPIs))))
          ]),
        ),
        //Switch button
        Positioned(
            bottom: PaddingD.padding16,
            left: 0,
            child: SizedBox(
              // alignment: Alignment.center,
              width: MyWidths.width_screen_padding(width),
              child: customRow(isCenter: true, children: [
                custom_button(
                    spacingHor: PaddingD.padding16,
                    paddingVer: PaddingD.pading08,
                    onTap: () {
                      debugPrint('click home');
                    },
                    pathAsset: MyAssets.home,
                    text: "HOME"),
                const SizedBox(
                  width: PaddingD.padding16,
                ),
                custom_button(
                    spacingHor: PaddingD.padding16,
                    paddingVer: PaddingD.pading08,
                    onTap: () {
                      debugPrint('click savepreset');
                    },
                    pathAsset: MyAssets.bookmark,
                    text: "SAVE PRESET")
              ]),
            )),
        Positioned(
            bottom: PaddingD.padding16,
            left: PaddingD.padding16,
            child: Obx(
              () => CustomSwitch(
                value: controllerGetX.isSwitch.value,
                onChanged: (bool val) {
                  controllerGetX.toggleSwitch();
                },
              ),
            )),
      ],
    );
  }
}
