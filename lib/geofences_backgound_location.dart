import 'dart:async';

import 'package:flutter/services.dart';

class GeofencesBackgoundLocation {
  static const MethodChannel _channel =
      const MethodChannel('geofences_backgound_location');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
