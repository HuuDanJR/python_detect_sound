import 'package:flutter/material.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';

Future showDialogSucess({context, dismissDuration}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return FutureBuilder(
        future: Future.delayed(dismissDuration).then((value) => true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Navigator.of(context).pop();
          }
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Use min to limit size
              children: [
                Image.asset(
                  'assets/sucess2.png', // Replace with your image path
                  height: 150, // Adjust the height as needed
                  width: 150, // Adjust the width as needed
                ),
                const SizedBox(
                    height: PaddingDefault
                        .pading08), // Add some space between image and text
                text_custom(text: 'Thank You!', size: 22, weight: FontWeight.w500),
              ],
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: Text('Close'),
            //   ),
            // ],
          );
        },
      );
    },
  );
}
