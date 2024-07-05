import 'package:feedback_customer/util/color_custom.dart';
import 'package:flutter/material.dart';
// Import the LoadingDialog widget

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevents the dialog from being dismissed by tapping outside
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(color: MyColor.grey,),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop(); // Hides the loading dialog
}
