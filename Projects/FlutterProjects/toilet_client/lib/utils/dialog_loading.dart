import 'package:flutter/material.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: MyColor.white,
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: PaddingDefault.pading08),child:text_custom(text:"Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }