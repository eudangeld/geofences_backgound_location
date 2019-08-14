import 'dart:async';

import 'package:flutter/services.dart';

class Geofences {
  static const MethodChannel _channel =
      const MethodChannel('geofences_backgound_location');

  static Future<String> get getPosition async {
    String position;
    try {
      position = await _channel.invokeMethod('getPosition');
    } on PlatformException catch (error) {
      position = 'Error geting position:\n' + error.toString();
    }
    return position;
  }

  static Future<String> get initLocation async {
    String position;
    try {
      position = await _channel.invokeMethod('initLocation');
    } on PlatformException catch (error) {
      position = 'Error geting position:\n' + error.toString();
    }
    return position;
  }
}
