import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/widget/custom_text.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar({context,String? message}){
   final snackBar = SnackBar(
    backgroundColor: MyColor.greenBG,
    duration: const Duration(seconds: 1),
    content: text_custom(text:'$message!',color:MyColor.white),
);
  return   ScaffoldMessenger.of(context).showSnackBar(snackBar);
}