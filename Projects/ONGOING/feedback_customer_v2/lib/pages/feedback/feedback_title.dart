import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';

Widget feedBackTitle(width) {
  return Container(
    alignment: Alignment.center,
    width: width,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'WHICH SERVICE(S)',
          style: TextStyle(
              fontSize: StringFactory.padding28,
              fontWeight: FontWeight.normal,
              color: MyColor.black_absulute),
          children: <TextSpan>[
            TextSpan(
                text: ' DID NOT',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: StringFactory.padding28,
                    color: MyColor.black_absulute)),
            TextSpan(
                text: ' MEET\nYOUR EXPECTATIONS?',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: StringFactory.padding28,
                    color: MyColor.black_absulute)),
          ],
        ),
      ),
    ),
  );
}


Widget feedBackTitle2(width) {
  return Container(
    alignment: Alignment.center,
    width: width,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'WHICH SERVICE(S) LEFT YOU',
          style: TextStyle(
              fontSize: StringFactory.padding28,
              fontWeight: FontWeight.normal,
              color: MyColor.black_absulute),
          children: <TextSpan>[
            TextSpan(
                text: ' SATISFIED?',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: StringFactory.padding28,
                    color: MyColor.black_absulute)),
            
          ],
        ),
      ),
    ),
  );
}
