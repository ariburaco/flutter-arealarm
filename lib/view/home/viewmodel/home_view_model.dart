import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/services/service_constants.dart';
import '../../alarms/view/alarms_view.dart';
import '../../map/view/map_view.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store, BaseViewModel {
  List<Widget> pages;
  var platform = const MethodChannel(ServiceConstants.LocationServiceChannel);

  PageController pageController;

  @action
  Future<void> startLocationService() async {
    try {
      await platform.invokeMethod('startService');
    } on PlatformException catch (e) {
      print(e.toString() + " Service NOT Started");
    }
  }

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
  }

  PageView buildPageView() {
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          changePage(index);
        },
        children: pages);
  }

  @observable
  int currentPageIndex = 0;

  @action
  void changePage(int index) {
    currentPageIndex = index;
  }
}
