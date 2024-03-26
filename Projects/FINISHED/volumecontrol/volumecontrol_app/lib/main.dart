import 'package:flutter/material.dart';
import 'package:volumn_control/page/control.dart';
import 'package:volumn_control/public/myAPIstring.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
        title: 'Volumn Control',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: MyString.FONTFAMILY,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        // home: HomePage()
        home: const ControlPage(
          indexPageView: 0,
        ));
  }
}
