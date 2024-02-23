import 'package:flutter/material.dart';

Widget customColumn({List<Widget>? children}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: children!);
}
