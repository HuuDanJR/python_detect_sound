import 'package:flutter/material.dart';

bool isSmallScreen(BuildContext context, width) {
  return MediaQuery.of(context).size.width < 800;
}

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 1200;
}

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width <= 1200;
}

double detectScreenWidthRatio({context, width}) {
  if (MediaQuery.of(context).size.width < 500) {
    return width * 0.8;
  }
  if (MediaQuery.of(context).size.width < 500  &&
      MediaQuery.of(context).size.width <800) {
    return width * 0.8;
  }
  if (MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width <= 1200) {
    return width * 0.5;
  }
  if (MediaQuery.of(context).size.width > 1200) {
    return width * 0.3;
  }
  return 2;
}
int detectScreenWidth({context, width}) {
  if (MediaQuery.of(context).size.width < 500) {
    return 2;
  }
  if (MediaQuery.of(context).size.width < 500  &&
      MediaQuery.of(context).size.width <800) {
    return 3;
  }
  if (MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width <= 1200) {
    return 5;
  }
  if (MediaQuery.of(context).size.width > 1200) {
    return 8;
  }
  return 2;
}

// 0 default, 1 mobile, 2 ipad, 3 web
