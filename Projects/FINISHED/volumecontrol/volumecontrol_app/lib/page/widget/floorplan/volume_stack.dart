import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/model/volume.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/volume_image_asset.dart';

Widget volumeStack({required MyGetXController controller,required width,required height}) {
  return
      // GetBuilder<MyGetXController>(
      //   builder: (controller) =>
      // );
      Obx(
    () => Stack(
      children: [
        // text_custom(text:controller.zoomRatio.value.toString(),size: TextSize.text24),
        Positioned(
          top:MyWidths.height_center_point(height),
          child: Container(width: width,height:1,color:Colors.grey)),
        volumeImageAsset(
          onTap: () {
            // print('tap volume1  ${controller.dx.value} ${controller.dy.value}');
            // controller.turnOnVisible();
            // controller.saveVolume(VolumeModel(
            //   id: 1,
            //   isShow: true,
            //   name: 'V1',
            //   minValue: 0,
            //   maxValue: 180,
            //   currentValue: 10,
            //   urlName: "servo1",
            // ));
          },
          name: 'V1',
          top: MyWidths.height_center_point(height)*1.4  + controller.dy.value,
          left: MyWidths.width_center_point(width)*.3  + controller.dx.value,
        ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume2');
        //   },
        //   name: 'V2',
        //   top: 530.5 + controller.dy.value,
        //   left: 329.5 + controller.dx.value,
        // ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume3');
            
        //   },
        //   name: 'V3',
        //   top: 548 + controller.dy.value,
        //   left: 426.5 + controller.dx.value,
        // ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume4');
        //   },
        //   name: 'V4',
        //   top: 657.5 + controller.dy.value,
        //   left: 426.5 + controller.dx.value,
        // ),
        volumeImageAsset(
          onTap: () {
            print('tap volume5');
            controller.turnOnVisible();
            controller.saveVolume(VolumeModel(
              id: 1,
              isShow: true,
              name: 'V5',
              minValue: 0,
              maxValue: MyWidths.SLIDER_MAX_VALUE,
              currentValue: 10,
              urlName: "servo5",
            ));
          },
          name: 'V5',
          // top: MyWidths.height_center_point(height)*1.2  + controller.dy.value,
          // left: MyWidths.width_center_point(width)*.95 + controller.dx.value,
        ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume6');
        //   },
        //   name: 'V6',
        //   top: 640.5 + controller.dy.value,
        //   left: 665.5 + controller.dx.value,
        // ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume7');
        //   },
        //   name: 'V7',
        //   top: 640.5 + controller.dy.value,
        //   left: 778.5 + controller.dx.value,
        // ),
        // volumeImageAsset(
        //   onTap: () {
        //     print('tap volume8');
        //   },
        //   name: 'V8',
        //   top: 515.5 + controller.dy.value,
        //   left: 778.5 + controller.dx.value,
        // ),
        //  volumeImageAsset(
        //   onTap: () {
        //     print('tap volume9');
        //   },
        //   name: 'V9',
        //   top: 449.5 + controller.dy.value,
        //   left: 552.5 + controller.dx.value,
        // ),
        //  volumeImageAsset(
        //   onTap: () {
        //     print('tap volume10');
        //   },
        //   name: 'V10',
        //   top: 335.5 + controller.dy.value,
        //   left: 552.5 + controller.dx.value,
        // ),
        //  volumeImageAsset(
        //   onTap: () {
        //     print('tap volume11');
        //   },
        //   name: 'V11',
        //   top: 150.5 * controller.zoomRatio.value+ controller.dy.value,
        //   left: 552.5  + controller.dx.value,
        // ),
        
      ],
    ),
  );
}
