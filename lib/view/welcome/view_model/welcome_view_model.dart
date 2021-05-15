import 'package:Arealarm/core/base/model/base_view_model.dart';
import 'package:Arealarm/core/constants/navigation/navigation_constants.dart';
import 'package:Arealarm/core/init/lang/locale_keys.g.dart';
import 'package:Arealarm/core/init/navigation/navigation_service.dart';
import 'package:Arealarm/view/utils/provider/background_service_manager.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool isGranted = false;

  @observable
  PageController? pageController;

  @observable
  String permissionText = "Permission awaiting!";

  void init() {
    pageController =
        new PageController(initialPage: currentPageIndex, keepPage: true);
    checkPermissions();
  }

  @action
  void changePage(int index) {
    currentPageIndex = index;
    pageController!.animateToPage(currentPageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void getStarted() {
    NavigationService.instance
        .navigateToPageClear(path: NavigationConstants.HOME_VIEW);
  }

  @action
  Future<void> getLocationPermissions() async {
    var locationStatus = await Permission.locationAlways.request();
    if (locationStatus == PermissionStatus.granted) {
      var batteryStatus = await Permission.ignoreBatteryOptimizations.request();

      if (batteryStatus == PermissionStatus.granted) {
        var notificationStatus = await Permission.notification.request();

        if (notificationStatus == PermissionStatus.granted) {
          checkPermissions();
          BackgroundServiceManager.instance.startAlarmService();
        }
      }
    }
  }

  Future<void> getBatteryPerrmissions() async {
    await Permission.ignoreBatteryOptimizations.request();
  }

  @action
  Future<void> checkPermissions() async {
    var locationStatus = await Permission.locationAlways.isGranted;
    var batteryStatus = await Permission.ignoreBatteryOptimizations.isGranted;
    var notificationStatus = await Permission.notification.isGranted;

    if (locationStatus && batteryStatus && notificationStatus) {
      isGranted = true;

      permissionText = LocaleKeys.permissionsGranted.tr();
      changePage(1);
    } else {
      permissionText = LocaleKeys.permissionsAwaiting.tr();
      isGranted = false;
      changePage(0);
    }
  }
}
