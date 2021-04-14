import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/constants/services/service_constants.dart';
import 'package:flutter_template/view/alarms/model/alarms_model.dart';
import 'package:flutter_template/view/utils/provider/alarm_provider.dart';
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
    if (alarm != null) {
      alarmArguments = (<String, dynamic>{
        'alarmId': alarm.alarmId,
        'latitude': alarm.lat,
        'longitude': alarm.long,
        'radius': alarm.radius,
      });
    } else {
      print("alarmList is null");
    }

    sendAlarmsToService();
  }

  Future<void> sendAlarmsToService() async {
    try {
      await platform.invokeMethod('startAlarmService', alarmArguments);
    } on PlatformException catch (e) {
      print(e.toString() + " Service NOT Started");
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