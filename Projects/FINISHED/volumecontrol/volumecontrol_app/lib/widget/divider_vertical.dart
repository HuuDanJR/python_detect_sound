import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';

Widget dividerVer(height) {
  return Container(
    alignment: Alignment.topCenter,
    // padding: const EdgeInsets.symmetric(horizontal: PaddingD.pading08),
    width: 1,
    height:(height-PaddingD.padding16),
    color:MyColor.grey_tab
  );
}
