import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/page/widget/preset/preset_page.dart';
import 'package:volumn_control/page/widget/preset/preset_page_detail_save.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/alert_dialog.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_snackbar.dart';
import 'package:volumn_control/widget/tab_text.dart';

class PresetPage extends StatefulWidget {
  const PresetPage({super.key});

  @override
  State<PresetPage> createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage> {
  int _currentPageIndex = 0;
  late PageController _pageController;
  final controllerGetX = Get.put(MyGetXController());
  @override
  void initState() {
    _currentPageIndex = 0;
    _pageController = PageController(initialPage: _currentPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerGetX.deletePreset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAPIs = MyAPIService();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // final formatDate = StringFormat();
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall),
        ),
        width: width,
        height: height,
        child: customColumn(children: [
          Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingD.padding24, vertical: PaddingD.pading08),
              height: MyWidths.tab_item_height_small(height),
              child: Row(
                children: [
                  tab_text(
                      isActive: _currentPageIndex == 0 ? true : false,
                      onTap: () {
                        goToPageView(0);
                      },
                      text: "LIST"),
                  const SizedBox(
                    width: PaddingD.padding16,
                  ),
                  tab_text(
                      isActive: _currentPageIndex == 1 ? true : false,
                      onTap: () {
                        goToPageView(1);
                      },
                      text: "DETAIL")
                ],
              )),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                debugPrint('current index: $index');
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                presetList(
                    serviceAPIs: serviceAPIs,
                    controllerGetX: controllerGetX,
                    onPress: () {
                      goToPageView(1);
                    }),
                PresetDetailSave(
                  onTapDelete: () {
                    debugPrint('tap delete in controlelr page');
                    goToPageView(0);
                  },
                  onTapFinish: () {
                    debugPrint('tap finish in controlelr page');
                    goToPageView(0);
                  },
                  onTapEdit: () {
                    debugPrint('tap edit in controller page');
                  },
                  onTapLoading: () {
                    debugPrint(
                        'tap loading in controller page ${controllerGetX.preset.value!.volumes.length}');
                    showCustomAlertDialog(
                        context: context,
                        function: () {
                          for (final element
                              in controllerGetX.preset.value!.volumes) {
                            debugPrint('deviceName & position: ${element.deviceName} ${element.currentValue}');
                            serviceAPIs.runDeviceFullURL(
                                    url: MyString.GET_DEVICE_API(
                                        deviceName: element.deviceName,
                                        position: '${element.currentValue}'))
                                .then((value) {})
                                .whenComplete(() {
                                  
                                });
                          }
                          Navigator.of(context).pop();
                        },
                        text: 'Do you want to apply this preset?');
                  },
                ),
              ],
            ),
          ),
        ]));
  }

  void goToPageView(int targetPageIndex) {
    controllerGetX.turnOffEditingPreset();
    setState(() {
      _pageController.animateToPage(
        targetPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
