import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/text_container.dart';

class VolumeImageAssetFocus extends StatefulWidget {
  final double top;
  final double left;
  final Function onTap;
  final String name;
  final int index;
  final int currentValue;
  final int type;
  const VolumeImageAssetFocus(
      {super.key,
      required this.currentValue,
      required this.top,
      required this.type,
      required this.index,
      required this.left,
      required this.onTap,
      required this.name});

  @override
  State<VolumeImageAssetFocus> createState() => _VolumeImageAssetFocusState();
}

class _VolumeImageAssetFocusState extends State<VolumeImageAssetFocus> {
  bool isActive = false;
  final controllerGetX = Get.put(MyGetXController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
          top: widget.top,
          left: widget.left,
          child: GestureDetector(
            onTap: () {
              // setState(() {
              //   isActive != isActive;
              // });
              widget.onTap();
              // print('volume index: ${controllerGetX.volume.value!.VolumeId} ${widget.index}');
            },
            child:
                // Container(
                //   padding: EdgeInsets.all(PaddingD.pading08),
                //   decoration: BoxDecoration(color :MyColor.greenOpa,
                //     border: Border.all(
                //       color:isActive?MyColor.green  : Colors.transparent
                //     ),
                //     borderRadius:BorderRadius.circular(PaddingD.pading08)
                //   ),
                //   child:

                customColumn(isTop: true, children: [
              textContainer(
                  type: widget.type,
                  text: '${widget.currentValue}',
                  isBool: false,
                  hasFocus: widget.index == controllerGetX.volumeIndex.value
                      ? true
                      : false),
              // const SizedBox(
              //   height: PaddingD.pading02,
              // ),
              customImageAsset(
                  path: widget.index == controllerGetX.volumeIndex.value
                      ? MyAssets.volume_active
                      : MyAssets.volume_normal2,
                  width: MyWidths.width_asset_smalest),
              // const SizedBox(
              //   height: PaddingD.pading02,
              // ),
              textContainer(
                  type: widget.type,
                  text: widget.name,
                  isBool: false,
                  hasFocus: widget.index == controllerGetX.volumeIndex.value
                      ? true
                      : false),
            ]),
            // )
          ),
        ));
  }
}
