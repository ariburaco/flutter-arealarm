import 'package:flutter/material.dart';
import '../../alarms/view/alarms_view.dart';
import '../../map/view/map_view.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'home_view_model.g.dart';

class HomeViewModel = _HomeViewModelBase with _$HomeViewModel;

abstract class _HomeViewModelBase with Store, BaseViewModel {
  List<Widget> pages;

  PageController pageController;

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
  int currentPageIndex = 1;

  @action
  void changePage(int index) {
    currentPageIndex = index;
  }
}
