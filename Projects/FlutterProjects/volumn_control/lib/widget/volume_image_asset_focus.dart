import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_text.dart';

class VolumeImageAssetFocus extends StatefulWidget {
  final double top;
  final double left;
  final Function onTap;
  final String name;
  final int index;
  const VolumeImageAssetFocus(
      {super.key,
      required this.top,
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

              customColumn(
                isTop: true,
                children: [
              customImageAsset(
                  path:widget.index == controllerGetX.volumeIndex.value ? MyAssets.volumn_on :  MyAssets.volumn_off,
                  width: MyWidths.width_asset_smalest) ,
              const SizedBox(
                height: PaddingD.pading02,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: PaddingD.pading12, vertical: 0.0),
                decoration: BoxDecoration(
                    color: MyColor.white,
                    border: Border.all(color: MyColor.grey_tab),
                    borderRadius: BorderRadius.circular(PaddingD.pading08)),
                child: text_custom(
                    text: widget.name,
                    // text:widget.index == controllerGetX.volumeIndex.value  ? '${widget.name}' : widget.name,
                    weight: FontWeight.bold,
                    color:widget.index == controllerGetX.volumeIndex.value ? MyColor.green:  MyColor.orange_accent,
                    size: TextSize.text20),
              )
            ]),
            // )
          ),
        ));
  }
}
