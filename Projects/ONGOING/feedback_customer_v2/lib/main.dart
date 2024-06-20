import 'package:feedback_customer/pages/feedback/feedbackbad_page.dart';
import 'package:feedback_customer/pages/home.dart';
import 'package:feedback_customer/pages/member/member.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/suggestion/suggestion.dart';
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
      title: 'Feedback Customer V2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/home': (context) => const HomePage(),
        '/feedback_bad': (context) =>  FeedbackBadPage(),
        '/feedback_good': (context) =>  FeedbackBadPage(),
        '/result': (context) =>  const ResultPage(),
        '/suggestion': (context) =>   SuggestionPage(),
        '/member': (context) =>   const MemberPage(),
        
      },
      home:  SuggestionPage()
      // home:  StaffPage()
    );
  }
}
