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



Widget buttonColor({onPressed, text,color,hasText=false,secondText}) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(PaddingDefault.padding24),
        child: Container(
          child: Material(
            child: InkWell(
              onTap: () {
                onPressed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: PaddingDefault.padding04),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.white),
                    borderRadius: BorderRadius.circular(PaddingDefault.pading08)),
                alignment: Alignment.center,
                width: 175.0,
                child: text_custom(
                  text: '$text',
                  color:MyColor.white,
                  size: TextSizeDefault.text18,
                  weight: FontWeight.bold,
                ),
              ),
            ),
            color: Colors.transparent,
          ),
          color: color,
        ),
      ),
      
      hasText==true? text_custom(text:secondText) : Container()
    ],
  );
}


Widget buttonColorFullCustom({required bool? hasIcon ,required icon, required double paddingVertical,onPressed, text,color,hasText=false,secondText,required double  width,required double textSize}) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(PaddingDefault.padding24),
        child: Container(
          child: Material(
            child: InkWell(
              onTap: () {
                onPressed();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical:paddingVertical ?? PaddingDefault.padding04),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.white),
                    borderRadius: BorderRadius.circular(PaddingDefault.pading08)),
                alignment: Alignment.center,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    hasIcon==true? icon : Container(),
                    hasIcon==true? SizedBox(width: TextSizeDefault.text08,) : Container(),
                    text_custom(
                      text: '$text',
                      color:MyColor.white,
                      size: textSize,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            color: Colors.transparent,
          ),
          color: color,
        ),
      ),
      
      hasText==true? text_custom(text:secondText) : Container()
    ],
  );
}