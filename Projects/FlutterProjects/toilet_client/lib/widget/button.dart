import 'package:flutter/material.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

Widget button({onPressed, text}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(PaddingDefault.padding24),
    child: Container(
      child: Material(
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: MyColor.white),
                borderRadius: BorderRadius.circular(PaddingDefault.padding24)),
            alignment: Alignment.center,
            width: 195.0,
            height: 50.0,
            child: text_custom(
              text: '$text',
              color:MyColor.white,
              size: TextSizeDefault.text32,
              weight: FontWeight.bold,
            ),
          ),
        ),
        color: Colors.transparent,
      ),
      color: MyColor.yellow3,
    ),
  );
}
