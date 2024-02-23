import 'package:flutter/material.dart';

Widget customRow({List<Widget>? children,isCenter=false}) {
  return Row(
    mainAxisAlignment:isCenter==true? MainAxisAlignment.center :  MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children!);
}
