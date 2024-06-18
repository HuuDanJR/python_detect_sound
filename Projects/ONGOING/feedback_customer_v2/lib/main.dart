import 'package:feedback_customer/feedback.dart';
import 'package:feedback_customer/home.dart';
import 'package:feedback_customer/result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/home': (context) => const HomePage(),
        '/feedback': (context) =>  FeedbackPage(),
        '/result': (context) =>  const ResultPage(),
      },
      home: const HomePage()
    );
  }
}
