import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageManager {
  static LanguageManager? _instance;
  static LanguageManager get instance {
    if (_instance == null) _instance = LanguageManager._init();
    return _instance!;
  }

  LanguageManager._init();

  final enLocale = Locale("en", "US");
  final trLocale = Locale("tr", "TR");

  List<Locale> get supportedLocales => [enLocale, trLocale];

  Locale? getDeviceLocale(BuildContext? context) {
    var matchedLocale = supportedLocales.where((element) =>
        element.languageCode == context!.deviceLocale.languageCode);
    if (matchedLocale.isNotEmpty)
      return matchedLocale.first;
    else
      supportedLocales.first;
  }
}

// flutter pub run easy_localization:generate  -O lib/core/init/lang -f keys -o locale_keys.g.dart --source-dir assets/lang
