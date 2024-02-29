import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/widget/floorplan/volume_stack.dart';
import 'package:volumn_control/public/deboucer.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider.dart';

class FloorPlanPage extends StatefulWidget {
  const FloorPlanPage({super.key});

  @override
  State<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  // late double valueSlider = 0;
  final double _scaleState = 1.0;
  PhotoViewControllerBase<PhotoViewControllerValue>? controllerPhoto;
  PhotoViewScaleStateController? controllerPhotoScale;
  final controllerGetX = Get.put(MyGetXController());
  final serviceAPIs = MyAPIService();
  final debouncer =Debouncer(milliseconds: 100, delay: const Duration(milliseconds: 100));

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          // padding: EdgeInsets.all(PaddingD.padding16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:BorderRadius.circular(MyWidths.width_borderRadiusSmall),
            color: MyColor.white,
          ),
          width: width,
          height: height,
          child: PhotoView(
            imageProvider: const AssetImage(MyAssets
                .map), // Replace 'assets/image.jpg' with your image path
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
              // borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall)
            ),
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.contained * 1,
            // maxScale: PhotoViewComputedScale.covered * 1.5,
            // maxScale: PhotoViewComputedScale.covered * 1.35,
            controller: controllerPhoto,
            scaleStateController: controllerPhotoScale,
            scaleStateChangedCallback: (scaleState) {
              debugPrint(scaleState.name);
              print('scaleState index: ${scaleState.index}');
              print('scaleState name: ${scaleState.name}');
              setState(() {
                if (scaleState.index == 0) {
                  print('initial');
                  controllerGetX.saveZoomRatio(1);
                } else if (scaleState.index == 1) {
                  print('covering');
                  controllerGetX.saveZoomRatio(.75);
                } else if (scaleState.index == 2) {
                  print('original size');
                  // controllerGetX.saveZoomRatio(.1);

                } else if (scaleState.index == 3) {
                  print('zoom in');
                  // controllerGetX.saveZoomRatio(.1);
                }
              });
            },
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(
                  value: event == null
                      ? null
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              );
            },
            filterQuality: FilterQuality.high,
            // enablePanAlways: true,
            onScaleEnd: (context, details, controllerValue) {
              print('onScaleEnd dx:${controllerValue.position.dx}');
              print('onScaleEnd dy:${controllerValue.position.dy}');
              controllerGetX.saveDxDy(
                  dxValue: controllerValue.position.dx,
                  dyValue: controllerValue.position.dy,);
            },
            // onTapDown: (context, details, controllerValue) {
            //   print('onTapDown dx:${controllerValue.position.dx}');
            //   print('onTapDown dy:${controllerValue.position.dy}');
            //   controllerGetX.saveDxDy(controllerValue.position.dx, controllerValue.position.dy);
            // },
            // onTapUp: (context, details, controllerValue) {
            //   print('onTapDown dx:${controllerValue.position.dx}');
            //   print('onTapDown dy:${controllerValue.position.dy}');
            //   controllerGetX.saveDxDy(controllerValue.position.dx, controllerValue.position.dy);
            // },
          ),
        ),
        //VOLUME ITEM STACK
        GetBuilder<MyGetXController>(
          builder: (controller) => volumeStack(
            controller: controller,
            width: width,
            height:height,
          ),
        ),

        //DISPLAY SLIDER
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
                          left: BorderSide(
                              color: MyColor.yellow_accent, width: 2)),
                    ),
                    child:
                        // customSliderGetX(
                        //     width: MyWidths.slider_item_width,
                        //     height: height * .55,
                        //     onClose: (){
                        //       // controllerGetX.turnOffVisible();
                        //     },
                        //     onChange: (double value) {
                        //       // controllerGetX.saveValueSlider(value);
                        //       // print(object)
                        //     }),

                        customSlider(
                            text: 'V5',
                            width: MyWidths.slider_item_width,
                            height: height * .5,
                            onClose: () {
                              controllerGetX.turnOffVisible();
                            },
                            onChange: (double value) {
                              controllerGetX.saveValueSlider(value);
                              debouncer.run(() {
                                debugPrint('value: ${controllerGetX.valueSlider.value}');
                                serviceAPIs.runDevice(
                                    position: controllerGetX.valueSlider.value,
                                    deviceName: "servo5");
                              });
                            }),
                  )
                : Container(),
          ),
        )
      ],
    );
  }
}
