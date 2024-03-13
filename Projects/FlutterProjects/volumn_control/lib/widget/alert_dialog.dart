import 'package:flutter/material.dart';
import 'package:volumn_control/public/mytextsize.dart';
import 'package:volumn_control/widget/custom_text.dart';

void showCustomAlertDialog(
    {required context, required function, required text}) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title:
                text_custom(text: 'Confirm This Action', size: TextSize.text22),
            content: text_custom(text: '$text'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: text_custom_center(text: "CANCEL")),
              TextButton(
                  onPressed: () {
                    function();
                  },
                  child: text_custom_center(text: "CONFIRM"))
            ],
          )));
}

void showCustomAlertDialog2Fun(
    {required context, required function, required text, functionCancel,required String textbutton}) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title:
                text_custom(text: 'Confirm This Action', size: TextSize.text22),
            content: text_custom(text: '$text'),
            actions: [
              TextButton(
                  onPressed: () {
                    functionCancel();
                  },
                  child: text_custom_center(text: "CANCEL")),
              TextButton(
                  onPressed: () {
                    function();
                  },
                  child: text_custom_center(text: "$textbutton"))
            ],
          )));
}

void showCustomUpdateDialog(
    {required functionFinish,
    required String buttonFinish,
    required functionCancel,
    required context,
    required function,
    required text,
    required String title,
    required String buttonCancel,
    required String buttonOK}) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: text_custom(text: title, size: TextSize.text22),
            content: text_custom(text: '$text'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    functionCancel();
                  },
                  child: text_custom_center(text: buttonCancel)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    functionFinish();
                  },
                  child: text_custom_center(text: buttonFinish)),
              TextButton(
                  onPressed: () {
                    function();
                  },
                  child: text_custom_center(text: buttonOK))
            ],
          )));
}
