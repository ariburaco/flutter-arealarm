import 'package:flutter/material.dart';
import 'package:flutter_template/view/utils/database/database_manager.dart';
import '../model/alarms_model.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'alarms_view_model.g.dart';

class AlarmsViewModel = _AlarmsViewModelBase with _$AlarmsViewModel;

abstract class _AlarmsViewModelBase with Store, BaseViewModel {
  @observable
  bool isLoading = false;

  @observable
  bool hasActiveAlarm = false;

  @observable
  int alarmCount = 0;

  @observable
  List<Alarm> alarmList = [];

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    changeLoading();
    getAlarmList();
    changeLoading();
  }

  @action
  Future<void> getAlarmList() async {
    alarmList = await DatabaseManager.instance.getAlarmList();
    alarmCount = alarmList.length;
    if (alarmList.length > 0)
      hasActiveAlarm = true;
    else
      hasActiveAlarm = false;
    print(alarmList.length);
  }

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }

  @action
  Future<void> deleteAllAlarms() async {
    await DatabaseManager.instance.deleteAllAlarm();
    getAlarmList();
  }
}
