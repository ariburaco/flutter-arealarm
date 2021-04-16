import 'package:flutter/cupertino.dart';
import '../../alarms/model/alarms_model.dart';
import '../database/database_manager.dart';
import 'background_service_provider.dart';

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
    await getAlarmList();
    await BackgroundServiceProdiver.instance.stopAllAlarmServices();
  }

  Future<int> getAlarmCount() async {
    return await DatabaseManager.instance.getAlarmCount();
  }

  Future<void> deleteSelectedAlarm(int alarmId) async {
    Alarm alarm = (await DatabaseManager.instance.getAlarm(alarmId))!;

    alarm.isAlarmActive = 0;
    await updateAlarm(alarmId, alarm);
    await DatabaseManager.instance.deleteAlarm(alarmId);
    await getAlarmList();
  }

  Future<void> addAlarmToDB(Alarm newAlarm) async {
    await DatabaseManager.instance.addAlarm(newAlarm);
    await addAlarmAddedToBG(newAlarm);
    await getAlarmList();

    // await addActiveAlarmsToBGService();
    //addAlarmAddedToBG(newAlarm);
  }

  Future<void> updateAlarm(int id, Alarm newAlarm) async {
    final result = await DatabaseManager.instance.updateAlarm(id, newAlarm);
    if (result) {
      print("alarm updated!!");
    } else {
      print("alarm couldn't updated");
    }
    await getAlarmList();
  }

  Future<void> addAlarmAddedToBG(Alarm newAlarm) async {
    await BackgroundServiceProdiver.instance.addAlarmToBGService(newAlarm);
  }

  Future<void> addActiveAlarmsToBGService() async {
    if (alarmList != null) if (alarmList.isNotEmpty)
      await BackgroundServiceProdiver.instance.checkExistensAlarms(alarmList);
  }
}
