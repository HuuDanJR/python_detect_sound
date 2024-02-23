import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget text_custom({color,double? size, weight, text,}) {
  return Text(
    '$text',
    style: GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: weight),
  );
}


Widget text_custom_2line({ double? size, FontWeight? weight, String? text,String? textSecond}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: '$text\n', // First line of text followed by a line break
          style:GoogleFonts.montserrat(fontSize: size, color: Colors.black, fontWeight: weight),
        ),
        
        TextSpan(
          text: '($textSecond)', // Second line of text
          style: GoogleFonts.montserrat(fontSize: size, color: Colors.black54, fontWeight: weight),
        ),
      ],
    ),
  );
}