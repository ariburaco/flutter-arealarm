import 'package:flutter/cupertino.dart';
import 'package:flutter_template/view/alarms/model/alarms_model.dart';
import 'package:flutter_template/view/utils/database/database_manager.dart';

class AlarmProdivder extends ChangeNotifier {
  List<Alarm> alarmList = [];
  bool hasActiveAlarm = false;
  int alarmCount = 0;

  Future<List<Alarm>> getAlarmList() async {
    alarmList = await DatabaseManager.instance.getAlarmList();
    alarmCount = alarmList.length;
    if (alarmList.length > 0) {
      hasActiveAlarm = true;
    } else
      hasActiveAlarm = false;

    print("Alarm Count: $alarmCount");
    notifyListeners();
    return alarmList;
  }

  Future<void> deleteAllAlarms() async {
    await DatabaseManager.instance.deleteAllAlarm();
    alarmCount = 0;
    //getAlarmList();
    notifyListeners();
  }
}
