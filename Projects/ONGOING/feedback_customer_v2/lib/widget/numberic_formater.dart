import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp numericRegex = RegExp(r'^[0-9]*$');
    if (numericRegex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}