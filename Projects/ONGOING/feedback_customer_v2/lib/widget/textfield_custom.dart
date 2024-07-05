import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/numberic_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextField(
    {required double width,
    required double height,
    String? hint,
    required Function onTap,
    required TextEditingController controller,
    required String text,
    bool? hasHeight = true,
    required Function onSubmitted,
    Function? onChanged,
    inputFormatters,
    required keyboarType}) {
  return SizedBox(
    height: hasHeight == true ? height : null,
    width: width,
    child: TextField(
      
      inputFormatters: inputFormatters,
      // onEditingComplete: () {
      //   onSubmitted();
      // },
      onTap: () {
        onTap();
      },
      maxLength: 100,
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
