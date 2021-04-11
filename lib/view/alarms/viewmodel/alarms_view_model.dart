import 'package:flutter/material.dart';
import 'package:flutter_template/view/utils/database/database_manager.dart';
import 'package:flutter_template/view/utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';
import '../model/alarms_model.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'alarms_view_model.g.dart';

class AlarmsViewModel = _AlarmsViewModelBase with _$AlarmsViewModel;

abstract class _AlarmsViewModelBase with Store, BaseViewModel {
  @observable
  bool isLoading = false;

  @computed
  bool get hasActiveAlarm =>
      Provider.of<AlarmProdivder>(context, listen: false).hasActiveAlarm;

  @computed
  int get alarmCount =>
      Provider.of<AlarmProdivder>(context, listen: false).alarmCount;

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
    alarmList = await Provider.of<AlarmProdivder>(context, listen: false)
        .getAlarmList();
  }

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }

  @action
  Future<void> deleteAllAlarms() async {
    await Provider.of<AlarmProdivder>(context, listen: false).deleteAllAlarms();
  }
}
