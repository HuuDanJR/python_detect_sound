import 'package:flutter/material.dart';

Widget customImageAsset({path, width,}) {
  return Image.asset(
    '$path',
    width: width,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.low,
  );
}
