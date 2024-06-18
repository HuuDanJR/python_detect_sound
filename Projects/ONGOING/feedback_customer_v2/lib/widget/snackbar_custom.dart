import 'package:feedback_customer/util/color_custom.dart';
import 'package:flutter/material.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar({context,String? message,}){
   final snackBar = SnackBar(
    backgroundColor: MyColor.grey_tab,
    duration: const Duration(seconds: 1),
    showCloseIcon: true,
    closeIconColor: MyColor.black_text,
    content: Text('$message!',style:TextStyle(fontSize: 22.0,fontWeight: FontWeight.w600,color:MyColor.black_text)),
);
  return   ScaffoldMessenger.of(context).showSnackBar(snackBar);
}



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBarSuccess({context,String? message,}){
   final snackBar = SnackBar(
    backgroundColor: MyColor.green2,
    duration: const Duration(seconds: 1),
    showCloseIcon: true,
    closeIconColor: MyColor.white,
    content: Text('$message!',style:TextStyle(fontSize: 22.0,fontWeight: FontWeight.w600,color:MyColor.white)),
);
  return   ScaffoldMessenger.of(context).showSnackBar(snackBar);
}