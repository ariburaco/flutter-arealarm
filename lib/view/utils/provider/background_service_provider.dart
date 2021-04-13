import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/constants/services/service_constants.dart';

class BackgroundServiceProdiver extends ChangeNotifier {
  final platform = const MethodChannel(ServiceConstants.LocationServiceChannel);

  Future<void> startLocationService() async {
    try {
      await platform.invokeMethod('startService');
    } on PlatformException catch (e) {
      print(e.toString() + " Service NOT Started");
    }
  }
}
