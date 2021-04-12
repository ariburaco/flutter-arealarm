import 'package:flutter/cupertino.dart';
import 'package:flutter_template/view/alarms/model/alarms_model.dart';
import 'package:flutter_template/view/utils/database/database_manager.dart';

class AlarmProdivder extends ChangeNotifier {
  List<Alarm> alarmList = [];
  bool hasActiveAlarm = false;
  int alarmCount = 0;

  Future<List<Alarm>> getAlarmList() async {
    await DatabaseManager.instance.databaseInit();
    alarmList = await DatabaseManager.instance.getAlarmList();
    alarmList =
        alarmList.where((element) => element.isAlarmActive == 1).toList();

    alarmCount = await getAlarmCount();
    if (alarmCount > 0) {
      hasActiveAlarm = true;
    } else
      hasActiveAlarm = false;
    notifyListeners();
    return alarmList;
  }

  Future<void> deleteAllAlarms() async {
    await DatabaseManager.instance.deleteAllAlarm();
    getAlarmList();
  }

  Future<int> getAlarmCount() async {
    return await DatabaseManager.instance.getAlarmCount();
  }

  Future<void> deleteSelectedAlarm(int alarmId) async {
    Alarm alarm = (await DatabaseManager.instance.getAlarm(alarmId))!;

    alarm.isAlarmActive = 0;
    updateAlarm(alarmId, alarm);
    await DatabaseManager.instance.deleteAlarm(alarmId);
    getAlarmList();
  }

  Future<void> addAlarmToDB(Alarm newAlarm) async {
    await DatabaseManager.instance.addAlarm(newAlarm);

    getAlarmList();
  }

  Future<void> updateAlarm(int id, Alarm newAlarm) async {
    final result = await DatabaseManager.instance.updateAlarm(id, newAlarm);
    if (result) {
      print("alarm updated!!");
    } else {
      print("alarm couldn't updated");
    }
    getAlarmList();
  }
}