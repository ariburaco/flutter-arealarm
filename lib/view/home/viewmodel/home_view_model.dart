import 'package:Arealarm/view/settings/view/settings_view.dart';
import 'package:Arealarm/view/utils/provider/alarm_provider.dart';
import 'package:Arealarm/view/utils/provider/background_service_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../core/base/model/base_view_model.dart';
import '../../alarms/view/alarms_view.dart';
import '../../map/view/map_view.dart';
part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store, BaseViewModel {
  late List<Widget> pages;

  PageController? pageController;

  @observable
  int currentPageIndex = 0;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    Provider.of<AlarmProvider>(context, listen: true).context = context;

    pageController =
        new PageController(initialPage: currentPageIndex, keepPage: true);
    pages = <Widget>[
      GoogleMapView(),
      AlarmsView(),
      SettingsView(),
    ];
    Provider.of<AlarmProvider>(context, listen: false).getCurrentSettings();
  }

  PageView buildPageView() {
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          changePage(index);
        },
        children: pages);
  }

  @action
  void changePage(int index) {
    currentPageIndex = index;
  }
}
