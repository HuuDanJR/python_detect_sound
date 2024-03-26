import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/public/functions.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/volume_image_asset_focus.dart';

class FloorPlanListGetX extends StatefulWidget {
  // final MyGetXController controller;
  FloorPlanListGetX({
    super.key,
    // required this.controller,
    // required this.controllerGetX,
  });

  @override
  State<FloorPlanListGetX> createState() => _FloorPlanListGetXState();
}

class _FloorPlanListGetXState extends State<FloorPlanListGetX> {
  final MyAPIService serviceAPIs = MyAPIService();

  final controller = Get.put(MyGetXController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
   
    return Obx(() {
      if (controller.volumesFloorPlan.isEmpty) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else {
        return 
         Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(MyWidths.width_borderRadiusSmall),
            // color: MyColor.white,
          ),
          width: width,
          height: MyWidths.height_child(height),
          child: 
          // child: const FloorPlanList()
         
        Stack(
          children: controller.volumesFloorPlan.asMap().entries.map((entry) {
            final index = entry.key;
            final volume = entry.value;
            return Positioned(
              child: VolumeImageAssetFocus(
                index: index + 1,
                currentValue: volume.currentValue.round(),
                onTap: () {
                  debugPrint('tap ${volume.name} ${volume.dx} ${volume.dy}');
                  controller.turnOnVisible();
                  controller.saveVolumeMap(
                    newVolume: volume,
                    index: index + 1,
                  );
                  controller.saveValueSlider(volume.currentValue);
                },
                type:volume.type,
                name: volume.name,
                top: calculateDyRatio(height, volume.dy),
                left: calculateDxRatio(width, volume.dx),
              ),
            );
          }).toList(),
        ),);
      }
    });
  }
}
