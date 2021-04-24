import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/view/utils/provider/background_service_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/base/model/base_view_model.dart';
import '../../../core/constants/services/service_constants.dart';
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
    pageController =
        new PageController(initialPage: currentPageIndex, keepPage: true);
    pages = <Widget>[
      GoogleMapView(),
      AlarmsView(),
      Container(color: Colors.blue),
    ];
    getPermissions();
    BackgroundServiceManager.instance.startAlarmService();
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

  Future<void> getPermissions() async {
    print(
        "First Batter optimiziation status: ${Permission.ignoreBatteryOptimizations.status}");
    await Permission.ignoreBatteryOptimizations.request();
    var answer = await Permission.ignoreBatteryOptimizations.status.isGranted;
    print("second Batter optimiziation status: $answer");

    // if (await Permission.location.isRestricted) {
    //   // The OS restricts access, for example because of parental controls.
    // }
  }
}
