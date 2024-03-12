import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/page/widget/floorplan/volume_stack.dart';
import 'package:volumn_control/public/deboucer.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/widget/volume_image_asset.dart';
import 'package:volumn_control/widget/volume_image_asset_focus.dart';

class FloorPlanList extends StatefulWidget {
  const FloorPlanList({super.key});

  @override
  State<FloorPlanList> createState() => _FloorPlanListState();
}

class _FloorPlanListState extends State<FloorPlanList> {
  final controllerGetX = Get.put(MyGetXController());
  final serviceAPIs = MyAPIService();
  final debouncer =
      Debouncer(milliseconds: 100, delay: const Duration(milliseconds: 100));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(children: [
      PhotoView(
        loadingBuilder: (context, event) {
          return Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? null
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          );
        },
        imageProvider: const AssetImage(
            MyAssets.map), // Replace 'assets/image.jpg' with your image path
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall)
        ),
        minScale: PhotoViewComputedScale.contained * 1.15,
        maxScale: PhotoViewComputedScale.contained * 1.15,
      ),
      Container(
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall),
          // color: MyColor.white,
        ),
        width: width,
        height: MyWidths.height_child(height),
        child: FutureBuilder(
            future: serviceAPIs.listVolme(),
            builder: ((context, snapshot) {
              late VolumeListModel model = snapshot.data as VolumeListModel;
              if (snapshot.data == null ||
                  (snapshot.data as VolumeListModel).data.isEmpty) {
                return text_custom_center(text: "No volumes found");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return text_custom_center(text: "An error orcur");
              }
              return Stack(
                  children: model.data.asMap().entries.map((entry) {
                final index = entry.key;
                final volume = entry.value;
                return Positioned(
                  child: VolumeImageAssetFocus(
                    index: index + 1,
                    onTap: () {
                      debugPrint('tap ${volume.name} ${volume.dx} ${volume.dy}');
                      controllerGetX.turnOnVisible();
                      controllerGetX.saveVolumeMap(newVolume: volume, index: index + 1);
                      controllerGetX.saveValueSlider(volume.currentValue);
                    },
                    name: volume.name,
                    top: volume.dy,
                    left: volume.dx,
                  ),
                );
              }).toList());
            })),
      ),
      Positioned(
          top: MyWidths.height_center_point(height),
          child: Container(height: 1, width: width, color: MyColor.grey_tab)),
      Positioned(
          left: MyWidths.width_center_point(width),
          child: RotatedBox(
              quarterTurns: 3,
              child:Container(height: 1, width: width, color: MyColor.grey_tab))),
      //View Slider and Adjust
      Obx(
        () => Positioned(
          right: 0,
          top: 0,
          child: controllerGetX.visible.value == true
              ? Container(
                  width: width / 5,
                  height: height,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: MyColor.bedgeLight,
                    border: Border(
                        left:
                            BorderSide(color: MyColor.yellow_accent, width: 2)),
                  ),
                  child: controllerGetX.volume.value != null
                      ? customSlider(
                          text: '${controllerGetX.volume.value!.name}',
                          width: MyWidths.slider_item_width,
                          height: height * .5,
                          onClose: () {
                            controllerGetX.turnOffVisible();
                            controllerGetX.resetVolumeIndex();
                          },
                          onChange: (double value) {
                            controllerGetX.saveValueSlider(value);
                            debouncer.run(() {
                              debugPrint('value: ${controllerGetX.valueSlider.value}');
                              serviceAPIs.runDeviceFullURL(
                              url: MyString.GET_DEVICE_API(
                                  deviceName: controllerGetX.volume.value!.deviceName,
                                  position: '${controllerGetX.valueSlider.value}'))
                              .then((value) {})
                              .whenComplete(() => null);
                              serviceAPIs.updateVolumeValue(id: controllerGetX.volume.value!.id, value: controllerGetX.valueSlider.value);
                            });
                          })
                      : text_custom_center(text: "no volume saved"),
                )
              : Container(),
        ),
      )
    ]);
  }
}
