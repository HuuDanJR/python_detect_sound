import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

Widget customerProgressIndicator() {
  return Center(
    child: SizedBox(
      width: StringFactory.padding36,
      height: StringFactory.padding36,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        color: MyColor.yellowMain,
      ),
    ),
  );
}
