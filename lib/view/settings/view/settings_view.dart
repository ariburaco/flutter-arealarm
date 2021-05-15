import 'package:Arealarm/core/base/extension/context_extension.dart';
import 'package:Arealarm/core/base/view/base_view.dart';
import 'package:Arealarm/core/init/lang/locale_keys.g.dart';
import 'package:Arealarm/view/settings/viewmodel/settings_viewmodel.dart';
import 'package:Arealarm/view/utils/provider/alarm_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
                    buildCheckPermissions(context, viewmodel)
                  ],
                )),
              ),
            ));
  }

  Padding buildCheckPermissions(
      BuildContext context, SettingsViewModel viewmodel) {
    return Padding(
        padding: context.paddingLowHorizontal,
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  context.theme.colorScheme.secondary),
              foregroundColor: MaterialStateProperty.all<Color>(
                  context.theme.colorScheme.primary),
            ),
            onPressed: viewmodel.gotoWelcomPage,
            child: Text(
              LocaleKeys.getLocationPermissions.tr(),
            )));
  }

  Card buildLanguageChoice(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.primary,
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
                value: Provider.of<AlarmProvider>(context, listen: false)
                    .getAppLanguage,
                items: context.supportedLocales.map((locale) {
                  return DropdownMenuItem(
                    child: new Text(locale.toLanguageTag()),
                    value: locale,
                  );
                }).toList(),
                onChanged: (Locale? locale) {
                  Provider.of<AlarmProvider>(context, listen: false)
                      .changeCurrentLanguage(locale!);
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
      color: context.theme.colorScheme.primary,
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
                    .getFocusMode,
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
