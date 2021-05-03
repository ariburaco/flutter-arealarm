import 'package:Arealarm/core/base/model/base_view_model.dart';
import 'package:Arealarm/core/constants/navigation/navigation_constants.dart';
import 'package:Arealarm/core/init/navigation/navigation_route/navigation_route.dart';
import 'package:Arealarm/core/init/navigation/navigation_service.dart';
import 'package:Arealarm/view/home/view/home_view.dart';
import 'package:Arealarm/view/utils/provider/background_service_manager.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
part 'welcome_view_model.g.dart';

class WelcomeViewModel = _WelcomeViewModelBase with _$WelcomeViewModel;

abstract class _WelcomeViewModelBase with Store, BaseViewModel {
  void setContext(BuildContext context) => this.context = context;

  @observable
  int currentPageIndex = 0;

  @observable
  PageController? pageController;

  void init() {
    pageController =
        new PageController(initialPage: currentPageIndex, keepPage: true);
  }

  @action
  void changePage(int index) {
    currentPageIndex = index;
    pageController!.animateToPage(currentPageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void getStarted() {
    NavigationService.instance
        .navigateToPage(path: NavigationConstants.HOME_VIEW);
  }

  Future<void> getLocationPermissions() async {
    var locationStatus = await Permission.locationAlways.request();
    if (locationStatus == PermissionStatus.granted) {
      BackgroundServiceManager.instance.startAlarmService();
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  Future<void> getBatteryPerrmissions() async {
    await Permission.ignoreBatteryOptimizations.request();
  }
}
