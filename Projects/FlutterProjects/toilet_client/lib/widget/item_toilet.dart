import 'package:flutter/material.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';


Widget rowToiletDisplay({onPress,List<String>? input}) {

List<dynamic> validateInput(List<String>? input) {
    return input?.map((item) {
      String imageAsset = 'assets/information.png'; // Default image asset
      // Add logic to map each input string to its corresponding image asset
      if (item == MyGetXController.NO_TOILET1) {
        imageAsset = MyGetXController.NO_TOILET1_image;
      } else if (item == MyGetXController.NO_TOILET2) {
        imageAsset = MyGetXController.NO_TOILET2_image;
      }
      else if (item == MyGetXController.NO_TOILET3) {
        imageAsset = MyGetXController.NO_TOILET3_image;
      }
      else if (item == MyGetXController.NO_TOILET4) {
        imageAsset = MyGetXController.NO_TOILET4_image;
      }
      else if (item == MyGetXController.NO_TOILET5) {
        imageAsset = MyGetXController.NO_TOILET5_image;
      }
      else if (item == MyGetXController.NO_TOILET6) {
        imageAsset = MyGetXController.NO_TOILET6_image;
      }
      else if (item == MyGetXController.NO_TOILET7) {
        imageAsset = MyGetXController.NO_TOILET7_image;
      }
      else if (item == MyGetXController.NO_TOILET8) {
        imageAsset = MyGetXController.NO_TOILET8_image;
      }
      return {'text': item, 'imageAsset': imageAsset};
    }).toList() ?? [];
  }

    List<dynamic> validatedList = validateInput(input);
  return  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:List.generate(
        input!.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:PaddingDefault.pading08),
          child: Column(
            children: [
              Container(
                                        padding: const EdgeInsets.all(PaddingDefault.pading08),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                                PaddingDefault.pading12),
                                            border: Border.all(
                                                color: MyColor.grey,
                                                width:  1)),
                                        child: Container(
                                          height: PaddingDefault.padding54,
                                          width: PaddingDefault.padding54,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(validatedList[index]['imageAsset']),
                                                  fit: BoxFit.contain,
                                                  filterQuality: FilterQuality.high)),
                                        ),
                                      ),
              text_custom(text:input[index],weight: FontWeight.w500,size: 12)
            ],
          ),
        ),
      ),
        ),
  );
}
