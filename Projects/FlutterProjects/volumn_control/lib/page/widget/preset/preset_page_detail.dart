// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:volumn_control/api/api_service.dart';
// import 'package:volumn_control/getx/getx_controller.dart';
// import 'package:volumn_control/public/myassets.dart';
// import 'package:volumn_control/public/mypadding.dart';
// import 'package:volumn_control/public/mytextsize.dart';
// import 'package:volumn_control/public/mywidths.dart';
// import 'package:volumn_control/widget/alert_dialog.dart';
// import 'package:volumn_control/widget/custom_button.dart';
// import 'package:volumn_control/widget/custom_column.dart';
// import 'package:volumn_control/widget/custom_row.dart';
// import 'package:volumn_control/widget/custom_slider_nodata.dart';
// import 'package:volumn_control/widget/custom_snackbar.dart';
// import 'package:volumn_control/widget/custom_text.dart';
// import 'package:volumn_control/public/deboucer.dart';

// Widget presetDetail() {
//   return text_custom_center(text: "please choose a preset to view ");
// }

// class PresetDetail extends StatefulWidget {
//   PresetDetail(
//       {super.key,
//       required this.onTapDelete,
//       required this.onTapEdit,
//       required this.onTapLoading});
//   Function onTapDelete, onTapEdit, onTapLoading;

//   @override
//   State<PresetDetail> createState() => _PresetDetailState();
// }

// class _PresetDetailState extends State<PresetDetail> {
//   final debouncer = Debouncer(milliseconds: 100, delay: const Duration(milliseconds: 100));

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final serviceAPIs = MyAPIService();
//     final itemWidthSlider = width / 11;
//     // final controllerGetX = Get.put(MyGetXController());
//     return GetBuilder<MyGetXController>(
//         builder: (controllerGetX) => controllerGetX.preset.value == null
//             ? text_custom_center(text: "click preset to view deta")
//             : Obx(() => SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: customColumn(isTop: true, children: [
//                     text_custom_center(
//                       text: controllerGetX.isEditingPreset.value == true
//                           ? "${controllerGetX.preset.value!.presetName.toUpperCase()} (adjust value of slider and it will be saved)"
//                           : controllerGetX.preset.value!.presetName
//                               .toUpperCase(),
//                       size: TextSize.text22,
//                     ),
//                     const Divider(),
//                     SizedBox(
//                         width: width,
//                         height: height / 1.55,
//                         child: ListView.builder(
//                           itemCount:
//                               controllerGetX.preset.value!.volumes.length,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: PaddingD.padding24),
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) => Padding(
//                               padding: const EdgeInsets.only(
//                                   left: PaddingD.padding24),
//                               child: customSliderFitNoData(
//                                   isTextNormal: true,
//                                   text: controllerGetX.preset.value!.volumes[index].name,
//                                   item_width: MyWidths.slider_item_width,
//                                   height: MyWidths.height_slider(height),
//                                   currentValue: controllerGetX.preset.value!.volumes[index].currentValue,
//                                   onChange: (double value) {
//                                     debouncer.run(() {
//                                       // serviceAPIs.updateVolumeValue(value:value,id:controllerGetX.preset.value!.volumes[index].id).then((value) => print(value));
//                                       print('id volumne & value: ${controllerGetX.preset.value!.volumes[index].id} $value');
//                                     });
//                                   })),
//                         )),
//                     SizedBox(
//                       width: MyWidths.width_screen_padding(width),
//                       child: customRow(isCenter: true, children: [
//                         custom_button(
//                             spacingHor: PaddingD.padding16,
//                             paddingVer: PaddingD.padding04,
//                             onTap: () {
//                               print('loading preset');
//                               widget.onTapLoading();
//                             },
//                             pathAsset: MyAssets.use,
//                             text: "LOADING PRESET"),
//                         const SizedBox(
//                           width: PaddingD.padding24,
//                         ),
//                         custom_button(
//                             spacingHor: PaddingD.padding16,
//                             paddingVer: PaddingD.padding04,
//                             onTap: () {
//                               // onTapDelete();
//                               showCustomAlertDialog(
//                                   text: "Are you sure delete this preset?",
//                                   context: context,
//                                   function: () {
//                                     print('click confirmed');
//                                     serviceAPIs
//                                         .deletePresetById(
//                                             id: controllerGetX.preset.value!.id)
//                                         .then((value) {
//                                       if (value['status'] == true) {
//                                         customSnackBar(
//                                             context: context,
//                                             message: value['message']);
//                                       }
//                                     }).whenComplete(() {
//                                       Navigator.of(context).pop();
//                                       widget.onTapDelete();
//                                     });
//                                   });
//                             },
//                             pathAsset: MyAssets.delete,
//                             text: "DELETE PRESET"),
//                       ]),
//                     )
//                   ]),
//                 )));
//   }
// }
