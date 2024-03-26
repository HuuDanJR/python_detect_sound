import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller_zonelist.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider_page.dart';



class ZoneList extends StatelessWidget {
  final ZoneListController controller;

  const ZoneList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(() {
      if (controller.volumes.isEmpty) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else {
        return ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: controller.volumes.length,
          padding: const EdgeInsets.symmetric(horizontal: PaddingD.padding24),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: PaddingD.padding24),
            child: CustomSliderPage(
              text: controller.volumes[index].name,
              isTextNormal: true,
              id: controller.volumes[index].id,
              deviceName: controller.volumes[index].deviceName,
              url: controller.volumes[index].url,
              valueSlider: controller.volumes[index].currentValue.toDouble(),
              item_width: MyWidths.slider_item_width,
              height: MyWidths.height_slider(height),
            ),
          ),
        );
      }
    });
  }
}
