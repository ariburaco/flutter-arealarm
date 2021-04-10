import 'package:flutter/material.dart';
import '../../init/navigation/navigation_service.dart';

abstract class BaseViewModel {
  late BuildContext context;

  //LocaleManager localeManager = LocaleManager.instance;
  NavigationService navigation = NavigationService.instance;

  void setContext(BuildContext context);
  void init();
}
