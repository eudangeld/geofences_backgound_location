import 'dart:async';

import 'package:flutter/services.dart';

class Geofences {
  static const MethodChannel _locationsChanel =
      const MethodChannel('dl.geofences.flutter/locations');
  static const MethodChannel _positionChanel =
      const MethodChannel('dl.geofences.flutter/positions');

  static Future<String> get getPosition async {
    String position;
    try {
      position = await _positionChanel.invokeMethod('getPosition');
    } on PlatformException catch (error) {
      position = 'Error geting position:\n' + error.toString();
    }
    print(position);
    return position;
  }

  static Future<String> initLocation() async {
    String location;

    try {
      location = await _locationsChanel.invokeMethod('initLocation');
    } on PlatformException catch (error) {
      location = 'Error geting position:\n' + error.toString();
    }
    print(location);
    return location;
  }
}
