import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/pages/feedback/feedback_page.dart';
import 'package:feedback_customer/pages/home.dart';
import 'package:feedback_customer/pages/member/member.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:feedback_customer/pages/suggestion/suggestion.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  MyGetXController? controllerGetx;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      debugPrint(locale.languageCode);
    });
  }

  @override
  void dispose() {
    getLocale().then((locale) {
      {
        setLocale(locale);
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    controllerGetx?.cancelResetAllTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Feedback Customer V2',
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          // fontFamily: 'AvertaStd',
          // textTheme: TextTheme(
           
          // ),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/home': (context) => const HomePage(),
          '/feedback': (context) => const FeedbackPage(),
          '/result': (context) => const ResultPage(),
          '/suggestion': (context) => SuggestionPage(),
          '/member': (context) => const MemberPage(),
        },
        home: SuggestionPage()
        // home:   StaffPage(
        //   statusName: 'g',
        //   hasNote: false,
        //   note:"",
        //   userData: NatinalityDatum(number: 1, title: 'title', preferredName: 'preferredName', isoCode2: 'isoCode2', nationality:[ 'nationality']),
        // )
        );
  }
}
