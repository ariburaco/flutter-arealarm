import 'package:flutter/material.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'alarms_view_model.g.dart';

class AlarmsViewModel = _AlarmsViewModelBase with _$AlarmsViewModel;

abstract class _AlarmsViewModelBase with Store, BaseViewModel {
  @observable
  bool hasActiveAlarm = false;

  @observable
  int alarmCount = 0;

  @observable
  List<String> alarmList = [];

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {}

  @action
  void addNewAlarm() {
    hasActiveAlarm = true;
    alarmList.add("value");
  }
}
