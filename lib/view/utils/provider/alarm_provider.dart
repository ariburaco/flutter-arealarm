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
    print("alarmCount" + alarmCount.toString());
    if (alarmCount == 0) {
      stopLocationStream();
    }
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

    //startLocationStream();
  }

  Future<void> stopLocationStream() async {
    if (positionStream != null) {
      await positionStream!.cancel();
      positionStream = null;
      print("CANCEL THE STREAM");
    }
    notifyListeners();
  }

  Future<void> calculateDistanceToAlarmPlaces(Position? currentPosition) async {
    if (currentPosition == null) {
      currentPosition = (await Geolocator.getLastKnownPosition())!;
    }
    for (var alarms in alarmList) {
      alarms.distance = Geolocator.distanceBetween(alarms.lat!, alarms.long!,
          currentPosition.latitude, currentPosition.longitude);
    }
    getNearestAlarm();
    notifyListeners();
  }

  void getNearestAlarm() {
    if (alarmList.isNotEmpty) {
      alarmList.sort((a, b) => a.distance!.compareTo(b.distance!));
      nearestAlarm = alarmList.first;
    }
  }
}
