import 'package:flutter/material.dart';

Widget customColumn({List<Widget>? children,isTop=false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment:isTop==true?MainAxisAlignment.start: MainAxisAlignment.center,
    children: children!);
}
