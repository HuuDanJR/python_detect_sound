import 'package:flutter/material.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider_page.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget zoneList({required MyAPIService serviceAPIs, height}) {
  return FutureBuilder(
    future: serviceAPIs.listVolme(),
    builder: (context, snapshot) {
      late VolumeListModel? model = snapshot.data;
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if (snapshot.hasError) {
        return Center(
          child: text_custom(text: "An Error Orcur ${snapshot.error}"),
        );
      }
      return 
      ListView.builder(
        itemCount: model!.data.length,
        padding: const EdgeInsets.symmetric(
        horizontal: PaddingD.padding24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left:PaddingD.padding24),
          child: CustomSliderPage(
            text: model.data[index].name,
            isTextNormal:true,
            id: model.data[index].id,
            // paddingLeft: PaddingD.padding24,
            deviceName: model.data[index].deviceName,
            url:model.data[index].url,
            valueSlider: model.data[index].currentValue.toDouble(),
            item_width: MyWidths.slider_item_width,
            height: MyWidths.height_slider(height),
          ),
        ),
      );
    },
  );
}
