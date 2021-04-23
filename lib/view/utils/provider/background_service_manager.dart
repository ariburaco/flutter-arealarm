import 'package:flutter/services.dart';
import '../../../core/constants/services/service_constants.dart';

class BackgroundServiceManager {
  static BackgroundServiceManager? _instace;
  static BackgroundServiceManager get instance {
    if (_instace == null) _instace = BackgroundServiceManager._init();
    return _instace!;
  }

  BackgroundServiceManager._init();

  MethodChannel platform =
      const MethodChannel(ServiceConstants.LocationServiceChannel);

  Future<void> initBackgroundService() async {
    await sendAlarmsToService();
    // platform.setMethodCallHandler((MethodCall call) async {
    //   switch (call.method) {
    //     case 'charlie':
    //       print("This method will be called when native fire " +
    //           call.arguments['alice']);
    //   }
    // });
  }

  // Future<void> checkExistensAlarms(List<Alarm>? alarmList) async {
  //   if (alarmList != null) {
  //     for (var alarm in alarmList) {
  //       await addAlarmToBGService(alarm);
  //     }
  //   }
  // }

  // Future<void> addAlarmToBGService(Alarm alarm) async {
  //   Map<String, dynamic>? alarmArguments = <String, dynamic>{
  //     'alarmId': alarm.alarmId,
  //     'isActive': alarm.isAlarmActive,
  //     'latitude': alarm.lat,
  //     'longitude': alarm.long,
  //     'radius': alarm.radius,
  //   };

  //   sendAlarmsToService(alarmArguments);
  // }

  // Future<void> updateAlarmFromBGService(Alarm alarm) async {
  //   Map<String, dynamic>? alarmArguments = <String, dynamic>{
  //     'alarmId': alarm.alarmId,
  //     'isActive': alarm.isAlarmActive,
  //     'latitude': alarm.lat,
  //     'longitude': alarm.long,
  //     'radius': alarm.radius,
  //   };

  //   updateSelectedAlarm(alarmArguments);
  // }

  // Future<void> removeAlarmFromBGService(Alarm alarm) async {
  //   Map<String, dynamic>? alarmArguments = <String, dynamic>{
  //     'alarmId': alarm.alarmId,
  //     'isActive': alarm.isAlarmActive,
  //     'latitude': alarm.lat,
  //     'longitude': alarm.long,
  //     'radius': alarm.radius,
  //   };

  //   stopSelectedAlarm(alarmArguments);
  // }

  Future<void> sendAlarmsToService() async {
    try {
      await platform.invokeMethod(ServiceConstants.StartAlarmService);
    } on PlatformException catch (e) {
      print(e.toString() + "Service NOT Started");
    }
  }

  // Future<void> stopSelectedAlarm(Map<String, dynamic>? alarmArguments) async {
  //   print(alarmArguments);
  //   try {
  //     await platform.invokeMethod(
  //         ServiceConstants.StopSelectedAlarmService, alarmArguments);
  //   } on PlatformException catch (e) {
  //     print(e.toString() + "Service NOT Started");
  //   }
  // }

  // Future<void> updateSelectedAlarm(Map<String, dynamic>? alarmArguments) async {
  //   try {
  //     await platform.invokeMethod(
  //         ServiceConstants.UpdateSelectedAlarmService, alarmArguments);
  //   } on PlatformException catch (e) {
  //     print(e.toString() + "Service NOT Started");
  //   }
  // }

  // Future<void> stopAllAlarmServices() async {
  //   try {
  //     await platform.invokeMethod(ServiceConstants.StopAllAlarmServices);
  //   } on PlatformException catch (e) {
  //     print(e.toString() + "All Service couldn't stopped!");
  //   }
  // }
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