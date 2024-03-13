import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/alert_dialog.dart';
import 'package:volumn_control/widget/custom_button.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_slider_nodata.dart';
import 'package:volumn_control/widget/custom_slider_page_nodata.dart';
import 'package:volumn_control/widget/custom_snackbar.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/public/deboucer.dart';

class PresetDetailSave extends StatefulWidget {
  PresetDetailSave(
      {super.key,
      required this.onTapDelete,
      required this.onTapEdit,
      required this.onTapFinish,
      required this.onTapLoading});
  Function onTapDelete, onTapEdit, onTapLoading,onTapFinish;

  @override
  State<PresetDetailSave> createState() => _PresetDetailSaveState();
}

class _PresetDetailSaveState extends State<PresetDetailSave> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer =Debouncer(milliseconds: 1000, delay: const Duration(milliseconds: 1000));
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final serviceAPIs = MyAPIService();
    final itemWidthSlider = width / 11;
    // final controllerGetX = Get.put(MyGetXController());
    return GetBuilder<MyGetXController>(
        builder: (controllerGetX) => controllerGetX.preset.value == null
            ? text_custom_center(text: "click preset to view deta")
            : Obx(() => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: customColumn(isTop: true, children: [
                    text_custom_center(
                      text: controllerGetX.isEditingPreset.value == true
                          ? "${controllerGetX.preset.value!.presetName.toUpperCase()} [ Adjust value of slider and it will be saved. ]"
                          : controllerGetX.preset.value!.presetName.toUpperCase(),
                      size: TextSize.text22,
                      // weight: FontWeight.bold
                    ),
                    const Divider(),
                    SizedBox(
                        width: width,
                        height: height / 1.515,
                        child: controllerGetX.isEditingPreset.value == false
                            ? ListView.builder(
                                itemCount:
                                    controllerGetX.preset.value!.volumes.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: PaddingD.padding24),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: PaddingD.padding24),
                                    child: customSliderFitNoData(
                                        isTextNormal: true,
                                        text: controllerGetX
                                            .preset.value!.volumes[index].name,
                                        item_width: MyWidths.slider_item_width,
                                        height: MyWidths.height_slider(height),
                                        currentValue: controllerGetX.preset
                                            .value!.volumes[index].currentValue,
                                        onChange: (double value) {})),
                              )
                            : Obx(() => ListView.builder(
                                  itemCount: controllerGetX.preset.value!.volumes.length,
                                  padding: const EdgeInsets.symmetric(horizontal: PaddingD.padding24),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(left: PaddingD.padding24),
                                    child: CustomSliderPageNoData(
                                      function: (value) {
                                        debouncer.run(() {
                                          serviceAPIs.updateVolumeValue(id: controllerGetX.preset.value!.volumes[index].id,value: value,).then((value) {
                                            debugPrint('current value : ${value['data']['currentValue']}');
                                            controllerGetX.updatePresetVolumeCurrentValue(
                                                    volumeId: controllerGetX.preset.value!.volumes[index].id,
                                                    newValue: value['data']['currentValue']);
                                          }).whenComplete(() {
                                            debugPrint('complete updateVolumeValue') ;
                                            showCustomUpdateDialog(
                                              buttonFinish: "FINISH",
                                              functionFinish:(){
                                                widget.onTapFinish();
                                              },
                                              functionCancel: (){
                                                // widget.onTapEdit();
                                                print('click button cancel');
                                              },
                                              buttonCancel: "CANCEL",
                                              buttonOK: "CONTINUE",
                                              context: context,title:"VOLUME'S VALUE UPDATED!",
                                              text: "This Volume's Value has been update sucessfully\nYou can choose 'CONTINUE' to continue editing\nUI will be updated when you exit page or edit other page",
                                              function:(){
                                                Navigator.of(context).pop();
                                            },);
                                          });
                                        });
                                      },
                                      text: controllerGetX
                                          .preset.value!.volumes[index].name,
                                      isTextNormal: true,
                                      id: controllerGetX
                                          .preset.value!.volumes[index].id,
                                      deviceName: controllerGetX.preset.value!
                                          .volumes[index].deviceName,
                                      url: controllerGetX
                                          .preset.value!.volumes[index].url,
                                      valueSlider: controllerGetX.preset.value!
                                          .volumes[index].currentValue
                                          .toDouble(),
                                      item_width: MyWidths.slider_item_width,
                                      height: MyWidths.height_slider(height),
                                    ),
                                  ),
                                ))),
                    SizedBox(
                      width: MyWidths.width_screen_padding(width),
                      child: customRow(isCenter: true, children: [
                        custom_button(
                            spacingHor: PaddingD.padding16,
                            paddingVer: PaddingD.padding04,
                            onTap: () {
                              print('tap loading in controller page: child page');
                              widget.onTapLoading();
                            },
                            pathAsset: 'assets/use.png',
                            text: "LOADING PRESET"),
                        const SizedBox(
                          width: PaddingD.padding24,
                        ),
                        custom_button(
                            spacingHor: PaddingD.padding16,
                            paddingVer: PaddingD.padding04,
                            onTap: () {
                              debugPrint('click edit preset');
                              controllerGetX.toggleEditingPreset();
                              widget.onTapEdit();
                            },
                            pathAsset: 'assets/edit.png',
                            text: controllerGetX.isEditingPreset.value == true
                                ? "EDIT PRESET (ON GOING)"
                                : "EDIT PRESET"),
                        const SizedBox(
                          width: PaddingD.padding24,
                        ),
                        custom_button(
                            spacingHor: PaddingD.padding16,
                            paddingVer: PaddingD.padding04,
                            onTap: () {
                              // onTapDelete();
                              showCustomAlertDialog(
                                  text: "Are you sure delete this preset?",
                                  context: context,
                                  function: () {
                                    print('click confirmed');
                                    serviceAPIs.deletePresetById(
                                            id: controllerGetX.preset.value!.id)
                                        .then((value) {
                                      if (value['status'] == true) {
                                        customSnackBar(
                                            context: context,
                                            message: value['message']);
                                      }
                                    }).whenComplete(() {
                                      Navigator.of(context).pop();
                                      widget.onTapDelete();
                                    });
                                  });
                            },
                            pathAsset: 'assets/delete.png',
                            text: "DELETE PRESET"),
                      ]),
                    )
                  ]),
                )));
  }
}
