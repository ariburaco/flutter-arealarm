import 'package:Arealarm/view/welcome/view/welcome_view.dart';
import 'package:flutter/material.dart';

import '../../../../view/home/view/home_view.dart';
import '../../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.HOME_VIEW:
        return normalNavigate(HomeView());
      case NavigationConstants.WELCOME_VIEW:
        return normalNavigate(WelcomeView());
      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
