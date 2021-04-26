import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/extension/context_extension.dart';
import 'package:flutter_template/core/init/lang/locale_keys.g.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        LocaleKeys.settings.tr(),
        style: context.textTheme.bodyText1,
      )),
      body: Padding(
        padding: context.paddingLowest,
        child: Container(
            child: ListView(
          children: [
            Card(
              color: context.colors.onBackground,
              child: Padding(
                padding: context.paddingLowest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.focus.tr(),
                      style: context.textTheme.bodyText1,
                    ),
                    Switch(value: false, onChanged: (bool val) {}),
                  ],
                ),
              ),
            ),
            Card(
              color: context.colors.onBackground,
              child: Padding(
                padding: context.paddingLowest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.language.tr(),
                      style: context.textTheme.bodyText1,
                    ),
                    Padding(
                      padding: context.paddingLowHorizontal,
                      child: DropdownButton<Locale>(
                        value: context.locale,
                        items: context.supportedLocales.map((locale) {
                          return DropdownMenuItem(
                            child: new Text(locale.toLanguageTag()),
                            value: locale,
                          );
                        }).toList(),
                        onChanged: (Locale? locale) {
                          context.setLocale(locale!);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
