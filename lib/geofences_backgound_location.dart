import 'dart:async';

import 'package:flutter/services.dart';

class Geofences {
  static const MethodChannel _locationsChanel =
      const MethodChannel('dl.geofences.flutter/locations');

  static Future<void> startMonitoring(String url) async {
    String location;
    try {
      location =
          await _locationsChanel.invokeMethod('startMonitoring', {"url": url});
    } on PlatformException catch (error) {
      location = 'Error geting position:\n' + error.toString();
    }
    print(location);
  }
}
