import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mywidths.dart';
import 'package:volumn_control/widget/custom_text.dart';

class PresetPage extends StatelessWidget {
  const PresetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
            alignment: Alignment.center,
            decoration:  BoxDecoration(
              color:MyColor.white,
                            borderRadius: BorderRadius.circular(MyWidths.width_borderRadiusSmall),

            ),
            width: width,
            height: height,
            child:text_custom(text:"preset"),
          
    );
  }
}
