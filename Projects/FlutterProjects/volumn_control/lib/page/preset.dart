import 'package:flutter/material.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/preset_list_model.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/page/widget/preset/preset_page.dart';
import 'package:volumn_control/page/widget/preset/preset_page_detail.dart';
import 'package:volumn_control/public/datetime_formater.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_row.dart';
import 'package:volumn_control/widget/custom_slider_page.dart';
import 'package:volumn_control/widget/custom_text.dart';
import 'package:volumn_control/widget/tab_text.dart';
import 'package:volumn_control/widget/text_icon_item.dart';

class PresetPage extends StatefulWidget {
  const PresetPage({super.key});

  @override
  State<PresetPage> createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage> {
  int _currentPageIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    _currentPageIndex = 0;
    _pageController = PageController(initialPage: _currentPageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAPIs = MyAPIService();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final formatDate = StringFormat();
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
            padding: const EdgeInsets.symmetric(horizontal: PaddingD.padding24,vertical: PaddingD.pading08),
                height: MyWidths.tab_item_height_small(height),
                child: Row(
                  children: [
                    tab_text(
                          isActive: _currentPageIndex == 0 ? true : false,
                          onTap: () {
                            goToPageView(0);
                          },
                          text: "LIST"
                    ),
                    const SizedBox(width: PaddingD.padding16,),
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
                    formatDate: formatDate,
                    onPress: () {
                      goToPageView(1);
                    }),
                presetDetail(),
              ],
            ),
          ),
        ]));
  }

  void goToPageView(int targetPageIndex) {
    setState(() {
      _pageController.animateToPage(
        targetPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
