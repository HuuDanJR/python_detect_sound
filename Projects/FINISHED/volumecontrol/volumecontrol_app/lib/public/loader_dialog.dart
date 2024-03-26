import 'package:flutter/material.dart';
import 'package:volumn_control/public/mycolors.dart';
import 'package:volumn_control/public/mypadding.dart';
import 'package:volumn_control/widget/custom_text.dart';

showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: MyColor.white,
      content: Row(
        children: [
          const CircularProgressIndicator.adaptive(),
          Container(margin: const EdgeInsets.only(left: PaddingD.pading08),child:text_custom(text:"Loading, Please wait for a moment" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }