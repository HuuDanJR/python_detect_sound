import 'package:flutter/material.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/model/volume_list_model.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_slider.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget zoneListSync({required MyAPIService serviceAPIs,height,}){
  return FutureBuilder(
                      future: serviceAPIs.listVolme(),
                      builder: (context, snapshot) {
                        late VolumeListModel? model = snapshot.data;
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: text_custom(text: "An Error Orcur."),
                          );
                        }
                        return ListView.builder(
                          itemCount: model!.data.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: PaddingD.padding24),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(left:PaddingD.padding24),
                            child: customSliderFit(
                            isTextNormal: true,
                            text: model.data[index].name,
                            item_width: MyWidths.slider_item_width,
                            height: MyWidths.height_slider(height),
                            onChange: (double value) {
                              // print(value);
                              // controllerGetX.saveValueSliderAll(value);
                              debugPrint('value change customSliderFit: $value');
                            })
                          ),
                        );
                      },
                    );
}