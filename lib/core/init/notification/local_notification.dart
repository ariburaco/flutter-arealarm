import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static LocalNotifications? _instace;
  static LocalNotifications get instance {
    if (_instace == null) _instace = LocalNotifications._init();
    return _instace!;
  }

  LocalNotifications._init();

  void initNotifications() {
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String? payload) {
    return notifications.cancelAll();
  }

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  NotificationDetails get _noSound {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'silent channel',
      'silent channel',
      'silent channel',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: false,
      ongoing: true,
    );
    final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

    return NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  Future showSilentNotification({
    required String title,
    required String body,
    int id = 0,
  }) =>
      _showNotification(title: title, body: body, id: id, type: _noSound);

  NotificationDetails get _ongoing {
    const int insistentFlag = 4;
    const int noClear = 32;
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    final androidChannelSpecifics = AndroidNotificationDetails(
      'new id', 'new name', 'new description',
      importance: Importance.max,
      priority: Priority.high,

      // ongoing: true,
      autoCancel: false,
      // playSound: true,
      // enableLights: true,
      // ledOnMs: 1000,
      ticker: 'ticker',
      // vibrationPattern: vibrationPattern,
      // enableVibration: true,
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      //timeoutAfter: 60 * 1000,

      //Exactly here
      additionalFlags: Int32List.fromList(<int>[insistentFlag, noClear]),
      // ledColor: const Color.fromARGB(255, 0, 255, 0),
      // ledOffMs: 500,
    );
    final iOSChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  Future showOngoingNotification({
    required String title,
    required String body,
    int id = 100,
  }) =>
      _showNotification(title: title, body: body, id: id, type: _ongoing);

  Future _showNotification({
    required String title,
    required String body,
    required NotificationDetails type,
    int id = 0,
    //Color ledColor = const Color.fromARGB(255, 0, 255, 0),
  }) =>
      notifications.show(id, title, body, type);
}
