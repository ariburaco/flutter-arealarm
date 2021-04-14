import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/services/service_constants.dart';
import '../../alarms/model/alarms_model.dart';
import 'alarm_provider.dart';
import 'package:provider/provider.dart';

class BackgroundServiceProdiver {
  static BackgroundServiceProdiver? _instace;
  static BackgroundServiceProdiver get instance {
    if (_instace == null) _instace = BackgroundServiceProdiver._init();
    return _instace!;
  }

  BackgroundServiceProdiver._init();

  final platform = const MethodChannel(ServiceConstants.LocationServiceChannel);

  Map<String, dynamic>? alarmArguments;

  Future<void> addAlarmToBGService(Alarm alarm) async {
    alarmArguments = <String, dynamic>{
      'alarmId': alarm.alarmId,
      'isActive': alarm.isAlarmActive,
      'latitude': alarm.lat,
      'longitude': alarm.long,
      'radius': alarm.radius,
    };

    sendAlarmsToService();
  }

  Future<void> sendAlarmsToService() async {
    try {
      await platform.invokeMethod(
          ServiceConstants.StartAlarmService, alarmArguments);
    } on PlatformException catch (e) {
      print(e.toString() + "Service NOT Started");
    }
  }

  Future<void> stopAlarmService(Alarm alarm) async {
    alarmArguments = <String, dynamic>{
      'alarmId': alarm.alarmId,
    };

    try {
      await platform.invokeMethod(
          ServiceConstants.StopAlarmService, alarmArguments);
    } on PlatformException catch (e) {
      print(e.toString() + "Service couldn't stopped!");
    }
  }

  Future<void> stopAllAlarmServices() async {
    try {
      await platform.invokeMethod(ServiceConstants.StopAllAlarmServices);
    } on PlatformException catch (e) {
      print(e.toString() + "All Service couldn't stopped!");
    }
  }
}


/*
Dart TO JAVA

Dart

  static void foo(String bar, bool baz) {
    _channel.invokeMethod('foo', <String, dynamic>{
      'bar': bar,
      'baz': baz,
    });
  }
Java

  String bar = call.argument("bar"); // .argument returns the correct type
  boolean baz = call.argument("baz"); // for the assignment


*/


/*
JAVA TO Dart

Java

  static void charlie(String alice, boolean bob) {
    HashMap<String, Object> arguments = new HashMap<>();
    arguments.put("alice", alice);
    arguments.put("bob", bob);
    channel.invokeMethod("charlie", arguments);
  }
Dart

    String alice = methodCall.arguments['alice'];
    bool bob = methodCall.arguments['bob'];



 */