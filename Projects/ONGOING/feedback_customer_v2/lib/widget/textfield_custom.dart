import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';

Widget customTextField(
    {required double width,
    required double height,
    String? hint,
    required TextEditingController controller,
    required String text,
    required Function onSubmitted,
    Function? onChanged,
    required keyboarType}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextField(
      maxLength: 350,
      onChanged: (value) {
        onChanged!(value);
      },
      keyboardType: keyboarType,
      onSubmitted: (value) {
        onSubmitted(value);
      },
      style: const TextStyle(
        fontSize: StringFactory
            .padding28, // Change this value to increase/decrease the text size
        fontWeight: FontWeight.w600, // Example to set the text to bold
      ),
      decoration: InputDecoration(
        hintText: hint ?? "",
        fillColor: MyColor.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: StringFactory.padding32,
            vertical: StringFactory.padding28),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(StringFactory.padding56),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(StringFactory.padding48),
        ),
        border: InputBorder.none,
      ),
    ),
  );
}
