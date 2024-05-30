import 'package:bingo_game/widget/snackbar.custom.dart';
import 'package:flutter/material.dart';

bool validateFieldSearch(String value, context) {
  RegExp numeric = RegExp(r'^-?[0-9]+$');
  if ((numeric.hasMatch(value)) == false) {
    ScaffoldMessenger.of(context).showSnackBar(mysnackBarError('Only Number Allow'));
  }
  return numeric.hasMatch(value);
}
