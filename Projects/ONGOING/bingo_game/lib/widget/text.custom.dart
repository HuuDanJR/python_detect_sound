import 'package:bingo_game/public/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget textcustom(text, style, ) {
  return Text(text, style: style);
}


Widget textCustomGrey({
  text,
  double? size,
}) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size, color: Colors.black38, fontWeight: FontWeight.bold));
}


Widget textCustom(
    {String? text, double? size, fontWeight = FontWeight.normal, required color}) {
  return Text(text!,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: FontWeight.bold));
}
Widget textCustomCenter(
    {String? text, double? size, fontWeight = FontWeight.normal, required color}) {
  return Text(text!,textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: FontWeight.bold));
}
Widget textCustomStyle(
    {required String? text,required double? size,required FontWeight fontWeight}) {
  return Text(text!,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: fontWeight));
}
Widget textCustom2(
    {String? text, double? size, }) {
  return Text(text!,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: FontWeight.normal));
}

Widget textCustomWithNumFormat(
    {String? text,
    double? size,
    fontWeight = FontWeight.normal,
    required NumberFormat format}) {
  return Text(format.format(int.parse(text!).abs()),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: FontWeight.bold));
}

Widget textCustomNormal({
  text,
  double? size,
}) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size,
          color: MyColor.black_text,
          fontWeight: FontWeight.normal));
}

Widget textCustomNormalColor(
    {text, double? size, color, fontWeight = FontWeight.normal, }) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight));
}

Widget textCustomNormalColorFont(
    {text, double? size, color, font, textalign = TextAlign.center}) {
  return Text(text,
      overflow: TextOverflow.ellipsis,
      textAlign: textalign,
      style: TextStyle(
        color: color,
        fontSize: size,
      ));
}