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
}

// flutter pub run easy_localization:generate  -O lib/core/init/lang -f keys -o locale_keys.g.dart --source-dir assets/lang
