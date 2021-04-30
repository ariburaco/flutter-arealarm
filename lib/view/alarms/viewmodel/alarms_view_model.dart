import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/base/model/base_view_model.dart';
import '../model/alarms_model.dart';

part 'alarms_view_model.g.dart';

class AlarmsViewModel = _AlarmsViewModelBase with _$AlarmsViewModel;

abstract class _AlarmsViewModelBase with Store, BaseViewModel {
  @observable
  List<Alarm> alarmList = [];

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {}
}
