import 'package:feedback_customer/util/string_factory.dart';
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

Widget customImageAsset({
  double? height,
  double? width,
  required String? image,
}) {
  return Container(
    height: height,
    width: width,
    // color:MyColor.green,
    padding: const EdgeInsets.symmetric(horizontal:StringFactory.padding38,vertical: StringFactory.padding16),
    child: Image.asset(
      image!,
      filterQuality: FilterQuality.high,
      alignment: Alignment.center,
      fit: BoxFit.contain,
    ),
  );
}


Widget customImageAssetCover({
  double? height,
  double? width,
  required String? image,
}) {
  return Container(
    height: height,
    width: width,
    padding: const EdgeInsets.all(StringFactory.padding4),
    child: Image.asset(
      image!,
      filterQuality: FilterQuality.high,
      alignment: Alignment.center,
      fit: BoxFit.contain,
    ),
  );
}