import 'package:Arealarm/core/base/model/base_view_model.dart';
import 'package:Arealarm/core/base/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
part 'welcome_view_model.g.dart';

class WelcomeViewModel = _WelcomeViewModelBase with _$WelcomeViewModel;

abstract class _WelcomeViewModelBase with Store, BaseViewModel {
  void setContext(BuildContext context) => this.context = context;

  void init() {}
}
