import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import '../../alarms/model/alarms_model.dart';
import '../database/database_manager.dart';
import 'background_service_provider.dart';

class AlarmProdivder extends ChangeNotifier {
  List<Alarm> alarmList = [];
  Alarm? nearestAlarm;
  bool hasActiveAlarm = false;
  int alarmCount = 0;
  static Position? currentPosition;

  StreamSubscription<Position>? positionStream;

  void initListener() {
    positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 0,
            intervalDuration: Duration(seconds: 5))
        .listen((Position? position) {
      if (position != null) {
        print("POS: " + position.toString());
        calculateDistanceToAlarmPlaces(position);
      }
    });

    startLocationStream();
  }

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
    await BackgroundServiceManager.instance.stopAllAlarmServices();
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
    await BackgroundServiceManager.instance.addAlarmToBGService(newAlarm);
  }

  Future<void> addActiveAlarmsToBGService() async {
    if (alarmList != null) if (alarmList.isNotEmpty)
      await BackgroundServiceManager.instance.checkExistensAlarms(alarmList);
  }

  void startLocationStream() {
    positionStream!.resume();
  }

  Future<void> stopLocationStream() async {
    if (positionStream != null) {
      positionStream!.cancel();
      print("CANCEL THE STREAM");
    }
  }

  void calculateDistanceToAlarmPlaces(Position? currentPosition) {
    if (currentPosition != null) {
      for (var alarms in alarmList) {
        alarms.distance = Geolocator.distanceBetween(alarms.lat!, alarms.long!,
            currentPosition.latitude, currentPosition.longitude);
      }
      getNearestAlarm();
      notifyListeners();
    }
  }

  void getNearestAlarm() {
    if (alarmList.isNotEmpty) {
      alarmList.sort((a, b) => a.distance!.compareTo(b.distance!));
      nearestAlarm = alarmList.first;
    }
  }
}
