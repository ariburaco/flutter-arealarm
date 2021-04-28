import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/base/extension/context_extension.dart';
import 'package:flutter_template/core/base/view/base_view.dart';
import 'package:flutter_template/core/init/lang/locale_keys.g.dart';
import 'package:flutter_template/view/settings/viewmodel/settings_viewmodel.dart';
import 'package:flutter_template/view/utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SettingsViewModel>(
        viewModel: SettingsViewModel(),
        onModelReady: (viewmodel) {
          viewmodel.setContext(context);
          viewmodel.init();
          // mapsViewModel.getCurrenPosition();
        },
        onPageBuilder: (BuildContext context, SettingsViewModel viewmodel) =>
            Scaffold(
              appBar: AppBar(
                  title: AutoSizeText(
                LocaleKeys.settings.tr(),
                maxLines: 1,
                minFontSize: 20,
                style: context.textTheme.bodyText1,
              )),
              body: Padding(
                padding: context.paddingLowest,
                child: Container(
                    child: ListView(
                  children: [
                    buildFocusSettings(context),
                    buildLanguageChoice(context),
                  ],
                )),
              ),
            ));
  }

  Card buildLanguageChoice(BuildContext context) {
    return Card(
      color: context.colors.onPrimary,
      child: Padding(
        padding: context.paddingLowHorizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              LocaleKeys.language.tr(),
              minFontSize: 16,
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
    );
  }

  Card buildFocusSettings(BuildContext context) {
    return Card(
      color: context.colors.onPrimary,
      child: Padding(
        padding: context.paddingLowHorizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              LocaleKeys.focus.tr(),
              minFontSize: 16,
              style: context.textTheme.bodyText1,
            ),
            Switch(
                splashRadius: 20,
                value: Provider.of<AlarmProvider>(context, listen: false)
                    .getFocusMode(),
                onChanged: (bool val) {
                  Provider.of<AlarmProvider>(context, listen: false)
                      .changeFocus(val);
                }),
          ],
        ),
      ),
    );
  }
}
