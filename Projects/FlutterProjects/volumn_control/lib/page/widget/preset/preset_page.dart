import 'package:flutter/material.dart';
import 'package:volumn_control/api/api_service.dart';
import 'package:volumn_control/getx/getx_controller.dart';
import 'package:volumn_control/model/preset_list_model.dart';
import 'package:volumn_control/public/myassets.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_column.dart';
import 'package:volumn_control/widget/custom_image_asset.dart';
import 'package:volumn_control/widget/custom_text.dart';

Widget presetList(
    {required MyAPIService serviceAPIs,
    required VoidCallback onPress,
    required MyGetXController controllerGetX}) {
  return FutureBuilder(
    future: serviceAPIs.listPreset(),
    builder: (context, snapshot) {
      late PresetListModel? model = snapshot.data;
      //  if (model!.data.isEmpty ) {
      //   return Center(child: text_custom(text: "No preset was created"));
      // }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else if (snapshot.data == null ||
          (snapshot.data as PresetListModel).data.isEmpty) {
        return Center(child: text_custom(text: "No presets were found"));
      } else if (snapshot.hasError) {
        return Center(
          child: text_custom(text: "An Error Orcur"),
        );
      }

      return OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
              itemCount: model!.data.length,
              padding: const EdgeInsets.symmetric(
                  horizontal: PaddingD.padding24, vertical: PaddingD.padding24),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.landscape ? 3 : 2,
                crossAxisSpacing: PaddingD.padding24, // Spacing between columns
                mainAxisSpacing: PaddingD.padding24, // Spacing between rows
                childAspectRatio: orientation == Orientation.landscape
                    ? 1
                    : 1, // Aspect ratio of each grid item
              ),
              itemBuilder: (context, index) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: MyColor.bedgeLight,
                      onTap: () {
                        // print('print $index');
                        onPress();
                        controllerGetX.savePreset(model.data[index]);
                        // controllerGetX.saveVolumes(model.data[index].volumes);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(PaddingD.pading08),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyColor.white,
                              borderRadius: BorderRadius.circular(
                                  MyWidths.width_borderRadiusSmall),
                            ),
                            child: customColumn(children: [
                              customImageAsset(
                                  path: MyAssets.bookmark,
                                  width: MyWidths.slider_item_width_small
                              ),
                              const Divider(color: MyColor.grey_tab),
                              text_custom(
                                  text: model.data[index].presetName.toUpperCase(),
                                  size: TextSize.text22,
                                  weight: FontWeight.normal),
                              // text_custom(
                              //     text:
                              //         formatDate.formatDateAndTime(model.data[index].createdAt),
                              //     size: TextSize.text14,
                              //     weight: FontWeight.normal),
                            ]),
                          ),
                          // Positioned(
                          //     right: 0,
                          //     top: 0,
                          //     child: IconButton(
                          //         onPressed: () {
                          //           print('click menu');
                          //           showDialog(
                          //             context: context,
                          //             builder: (context) => AlertDialog(
                          //               title: text_custom(
                          //                 text: "ENTER PRESET NAME",
                          //               ),
                          //               content: Column(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 children: [
                          //                   TextButton(
                          //                       onPressed: () {},
                          //                       child:
                          //                           text_custom(text: "VIEW")),
                          //                   TextButton(
                          //                       onPressed: () {},
                          //                       child: text_custom(
                          //                           text: "EDIT NAME")),
                          //                   TextButton(
                          //                       onPressed: () {
                          //                         print(
                          //                             model.data[index].id);
                          //                         serviceAPIs
                          //                             .deletePresetById(
                          //                                 id: model
                          //                                     .data[index].id)
                          //                             .then((value) =>
                          //                                 customSnackBar(
                          //                                     context: context,
                          //                                     message:
                          //                                         "${value['message']}"))
                          //                             .whenComplete(() =>
                          //                                 Navigator.of(context)
                          //                                     .pop());
                          //                       },
                          //                       child: text_custom(
                          //                           text: "DELETE")),
                          //                 ],
                          //               ),
                          //               actions: [
                          //                 TextButton(
                          //                     onPressed: () {
                          //                       Navigator.of(context).pop();
                          //                     },
                          //                     child: text_custom(
                          //                         text: "CANCEL",
                          //                         color: MyColor.black_text)),
                          //               ],
                          //             ),
                          //           );
                          //         },
                          //         icon: const Icon(Icons.more_vert_outlined)))
                        ],
                      ),
                    ),
                  ));
        },
      );
    },
  );
}
