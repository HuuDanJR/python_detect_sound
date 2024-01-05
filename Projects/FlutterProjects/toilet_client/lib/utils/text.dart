import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget text_custom({color,double? size, weight, text}) {
  return Text(
    '$text',
    style: GoogleFonts.montserrat(
        fontSize: size, color: color, fontWeight: weight),
  );
}
