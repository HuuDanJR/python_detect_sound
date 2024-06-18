import 'package:flutter/material.dart';

Widget customImageAssetText(
    {double? height,
    double? width,
    required String? image,
    required String? text}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: height! / 5,
        width: width! / 3,
        decoration: const BoxDecoration(),
        child: Image.asset(
          image!,
          filterQuality: FilterQuality.high,
          alignment: Alignment.bottomCenter,
          fit: BoxFit.contain,
        ),

      ),
      const SizedBox(
        height: 24.0,
      ),
      Text(
        text!,
        style: const TextStyle(fontSize: 42.0),
      )
    ],
  );
}
