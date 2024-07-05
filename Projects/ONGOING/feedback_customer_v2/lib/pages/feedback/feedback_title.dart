import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';

Widget feedBackTitle(width,context) {
  return Container(
    alignment: Alignment.center,
    width: width,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text:  TextSpan(
          // text: 'WHICH SERVICE(S)',
          text: translation(context).service_title_a,
          style: const TextStyle(
              fontSize: StringFactory.padding28,
              fontWeight: FontWeight.normal,
              color: MyColor.black_absulute),
          children: <TextSpan>[
            TextSpan(
                text: translation(context).service_title_b,
                // text: ' DID NOT',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: StringFactory.padding28,
                    color: MyColor.black_absulute)),
            TextSpan(
                text:translation(context).service_title_c,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: StringFactory.padding28,
                    color: MyColor.black_absulute)),
          ],
        ),
      ),
    ),
  );
}


Widget feedBackTitle2(width,context) {
  return Container(
    alignment: Alignment.center,
    width: width,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text:  TextSpan(
          text:translation(context).service_title_sub_a,
          style: const TextStyle(
              fontSize: StringFactory.padding32,
              fontWeight: FontWeight.normal,
              color: MyColor.black_absulute),
          children: <TextSpan>[
            TextSpan(
                text: translation(context).service_title_sub_b,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: StringFactory.padding32,
                    color: MyColor.black_absulute)),
            TextSpan(
                text: translation(context).service_title_sub_c,
                style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: StringFactory.padding32,
                    color: MyColor.black_absulute)),
            
          ],
        ),
      ),
    ),
  );
}
