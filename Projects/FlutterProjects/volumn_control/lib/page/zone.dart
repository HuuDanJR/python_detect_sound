import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/widget/zone/zone_list.dart';
import 'package:volumn_control/page/widget/zone/zone_list_sync.dart';
import 'package:volumn_control/public/deboucer.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_button.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_snackbar.dart';
import 'package:volumn_control/widget/custom_switch.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/widget/divider_vertical.dart';
import 'package:uuid/uuid.dart';

class ZonePage extends StatefulWidget {
  const ZonePage({super.key});

  @override
  State<ZonePage> createState() => _ZonePageState();
}

class _ZonePageState extends State<ZonePage> {
  late final bool _switchValue = false;
  final uuid = const Uuid();
  final controllerGetX = Get.put(MyGetXController());
  final serviceAPIs = MyAPIService();
  final TextEditingController controllerTextPreset = TextEditingController();
    final debouncer =  Debouncer(milliseconds: 500, delay: const Duration(milliseconds: 1000));


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final itemWidthSlider = width / 11;
    return Obx(() => Stack(
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
              child: customRow(children: [
                SizedBox(
                  width: itemWidthSlider,
                  height: height,
                  child: customSliderFit(
                      isTextNormal: true,
                      text: 'ALL',
                      item_width: MyWidths.slider_item_width,
                      height: MyWidths.height_slider(height),
                      onChange: (double value) {
                        if (controllerGetX.isSwitch == true) {
                          // serviceAPIs.updateVolumeValue()
                          controllerGetX.saveValueSliderAll(value:value,);
                          controllerGetX.updateValueSliderAll(value,);
                          controllerGetX.toggleHasChangeValueSlider();
                          print('customSliderFit ALL : ACTIVE => $value');
                        } else {
                          print('customSliderFit ALL : NOT ACTIVE');
                        }
                      }),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: dividerVer(height / 2)),
                Expanded(
                    child: SizedBox(
                        width: width - itemWidthSlider,
                        height: height,
                        child: controllerGetX.isSwitch.value == true
                            ? zoneListSync(
                                height: height,
                                serviceAPIs: serviceAPIs,
                              )
                            : 
                            zoneList(height: height, serviceAPIs: serviceAPIs)
                            ))
              ]),
            ),
            //Switch button
            Positioned(
                bottom: PaddingD.pading08,
                left: 0,
                child: SizedBox(
                  // alignment: Alignment.center,
                  width: MyWidths.width_screen_padding(width),
                  child: customRow(isCenter: true, children: [
                    // custom_button(
                    //     spacingHor: PaddingD.padding16,
                    //     paddingVer: PaddingD.padding04,
                    //     onTap: () {
                    //       debugPrint('click home');
                    //     },
                    //     pathAsset: MyAssets.home,
                    //     text: "HOME"),
                    // const SizedBox(
                    //   width: PaddingD.padding16,
                    // ),
                    custom_button(
                        spacingHor: PaddingD.padding16,
                        paddingVer: PaddingD.padding04,
                        onTap: () {
                          validateRequest(
                                      context: context,
                                      controllerGetX: controllerGetX) == false
                              ? null
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: text_custom(
                                      text: "ENTER PRESET NAME",
                                    ),
                                    content: TextField(
                                      controller: controllerTextPreset,
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(
                                              fontFamily: MyString.FONTFAMILY),
                                          hintText: 'preset name ###'),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: text_custom(
                                              text: "CANCEL",
                                              color: MyColor.black_text)),
                                      TextButton(
                                          onPressed: () {
                                            for (var element in controllerGetX
                                                .getListVolume()) {
                                              print(element.currentValue);
                                            }
                                            validatefield(controllerTextPreset,context) == true
                                                ? serviceAPIs.createPresetFix(
                                                        presetID: uuid.v1(),
                                                        presetName:controllerTextPreset.text,
                                                  ).then((value) => 
                                                    // print('createPresetFix $value')
                                                    customSnackBar(
                                                        context: context,
                                                        message:'Create Preset ${value['presetName']} successfully')
                                                    )
                                                    .whenComplete(() {
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      controllerTextPreset.text == '';
                                                    });
                                                  })
                                                : null;
                                          },
                                          child: text_custom(text: "CONFIRM"))
                                    ],
                                  ),
                                );
                        },
                        pathAsset: MyAssets.bookmark,
                        text: !controllerGetX.isSwitch.value
                            ? "SAVE PRESET "
                            : "SAVE PRESET (SYNC MODE)")
                  ]),
                )),
            Positioned(
              bottom: PaddingD.pading08,
              left: PaddingD.pading08,
              child: CustomSwitch(
                value: controllerGetX.isSwitch.value,
                onChanged: (bool val) {
                  controllerGetX.toggleSwitch();
                },
              ),
            ),
          ],
        ));
  }
}

bool validatefield(TextEditingController? controllerText, context) {
  if (controllerText!.text.isEmpty) {
    customSnackBar(context: context, message: "Please input preset name");
    return false;
  }
  return true;
}

bool validateRequest({controllerGetX, context}) {
  debugPrint('click savepreset');
  debugPrint(
      '${controllerGetX.isSwitch.value} ${controllerGetX.valueSliderAll.value}');
  if (controllerGetX.isSwitch.value == true &&
      controllerGetX.valueSliderAll.value == 0.0) {
    customSnackBar(
        context: context,
        message: "In sync mode, please make a change in slider all first");
    return false;
  }
  return true;
}
