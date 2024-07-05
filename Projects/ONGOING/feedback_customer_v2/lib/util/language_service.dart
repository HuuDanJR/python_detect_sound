import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String KOREA = 'ko';
const String CHINA = 'zh';
const String JAPANESE = 'ja';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case KOREA:
      return const Locale(KOREA, "");

    case CHINA:
      return const Locale(CHINA, "");
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}

extension TranslationExtension on BuildContext {
  String getString(String key) {
    return getTranslation(this, key);
  }
}

String getTranslation(BuildContext context, String key) {
  final localizations = AppLocalizations.of(context);
  switch (key) {
    case 'item_gaming_exp':
      return localizations!.item_gaming_exp;
    case 'item_staff':
      return localizations!.item_staff;
    case 'item_food':
      return localizations!.item_food;
    case 'item_clean':
      return localizations!.item_clean;

    default:
      return key;
  }
}
