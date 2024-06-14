import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/public/strings.dart';
import 'package:bingo_game/widget/image.asset.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:flutter/material.dart';


mysnackBar(message) {
  return SnackBar(
    // backgroundColor: MyColor.white,
    duration: const Duration(milliseconds: 400),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        textCustomNormalColor(
          text: message,
          color: MyColor.white,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(
          width: StringFactory.padding,
        ),
        imageAssetSmall('assets/icons/success.png'),
      ],
    ),
    // action: SnackBarAction(
    //   textColor: Colors.grey,
    //   label: 'CLOSE',
    //   onPressed: () {},
    // )
  );
}

mysnackbarWithContext(
    {required BuildContext context, required String message,required bool hasIcon}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 1000),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        textCustomNormalColor(
          text: message,
          color: MyColor.white,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(
          width: StringFactory.padding,
        ),
        hasIcon == true ?  imageAssetSmall('assets/icons/success.png') : Container(),
      ],
    ),
  ));
}

mysnackbarWithContextError(
    {required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // backgroundColor: MyColor.white,
      duration: const Duration(milliseconds: 400),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          textCustomNormalColor(
            text: message,
            color: MyColor.white,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(
            width: StringFactory.padding,
          ),
          imageAssetSmall('assets/icons/error.png'),
        ],
      )));
}

mysnackBarError(message) {
  return SnackBar(
    // backgroundColor: MyColor.white,
    duration: const Duration(milliseconds: 400),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        textCustomNormalColor(
          text: message,
          color: MyColor.white,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(
          width: StringFactory.padding,
        ),
        imageAssetSmall('assets/icons/error.png'),
      ],
    ),
    // action: SnackBarAction(
    //   textColor: Colors.grey,
    //   label: 'CLOSE',
    //   onPressed: () {},
    // )
  );
}
