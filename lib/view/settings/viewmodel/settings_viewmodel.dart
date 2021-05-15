import 'package:Arealarm/core/base/model/base_view_model.dart';
import 'package:Arealarm/core/constants/navigation/navigation_constants.dart';
import 'package:Arealarm/core/init/navigation/navigation_service.dart';
import 'package:Arealarm/view/utils/provider/alarm_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
part 'settings_viewmodel.g.dart';

class SettingsViewModel = _SettingsViewModelBase with _$SettingsViewModel;

abstract class _SettingsViewModelBase with Store, BaseViewModel {
  @override
  void init() {}

  @override
  void setContext(BuildContext context) {
    this.context = context;
    Provider.of<AlarmProvider>(context, listen: true).context = context;
  }

  void gotoWelcomPage() {
    NavigationService.instance
        .navigateToPageClear(path: NavigationConstants.WELCOME_VIEW);
  }
}
