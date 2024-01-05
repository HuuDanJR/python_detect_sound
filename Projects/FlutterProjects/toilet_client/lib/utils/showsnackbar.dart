import 'package:flutter/material.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';

void showSnackBar({String? message, BuildContext? context}) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 1),
    backgroundColor: MyColor.black_text,
    content: Text(
      message!,
      style: const TextStyle(
        fontFamily: 'OpenSan',
        fontSize: TextSizeDefault.text16,
        color: MyColor.white,
      ),
    ),
  );
  ScaffoldMessenger.of(context!).showSnackBar(snackBar);
}