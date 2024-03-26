import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller_zonelist.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/functions.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/widget/volume_image_asset_focus.dart';

class FloorPlanList extends StatefulWidget {
  const FloorPlanList({super.key});

  @override
  State<FloorPlanList> createState() => _FloorPlanListState();
}

class _FloorPlanListState extends State<FloorPlanList> {
  // final controllerGetX = Get.put(MyGetXController());
  // final controllerZoneList = Get.put(ZoneListController());
  final serviceAPIs = MyAPIService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<MyGetXController>(builder:(controllerGetX) => Container(
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
              if (snapshot.data == null || (snapshot.data as VolumeListModel).data.isEmpty) {
                return text_custom_center(text: "No volumes found");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
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
                    currentValue: (volume.currentValue.round()),
                    type: volume.type,
                    onTap: () {
                      debugPrint('tap floor plan list ${volume.name} ${volume.dx} ${volume.dy}');
                      controllerGetX.turnOnVisible();
                      controllerGetX.saveVolumeMap(newVolume: volume, index: index + 1);
                      controllerGetX.saveValueSlider(volume.currentValue);
                    },
                    name: volume.name,
                    // top: volume.dy,
                    // left: volume.dx,
                    top: calculateDyRatio(height, volume.dy),
                    left: calculateDxRatio(width, volume.dx),
                  ),
                );
              }).toList());
            }))));
  }
}
