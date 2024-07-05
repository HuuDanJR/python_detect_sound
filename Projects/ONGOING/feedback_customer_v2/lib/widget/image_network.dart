import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/custom_progressindicator.dart';
import 'package:flutter/material.dart';

Widget loadingImage({String? networkUrl, isCover = true}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(StringFactory.padding18),
    child: CachedNetworkImage(
      imageUrl: "$networkUrl",
      fit: isCover == true ? BoxFit.cover : BoxFit.contain,
      // placeholder: (context, url) => CircularProgressIndicator(),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
        customerProgressIndicator(),
      // progressIndicatorBuilder: (context, url, downloadProgress) =>
      //   CircularProgressIndicator(
      //   value: downloadProgress.progress,
      //   strokeWidth: 1.0,
      //   color: MyColor.grey_tab,
      // ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.verified_user, color: MyColor.black_absulute,size: StringFactory.padding28,),
    ),
  );
}
