import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geofences_backgound_location/geofences_backgound_location.dart';

void main() {
  const MethodChannel channel = MethodChannel('geofences_backgound_location');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await GeofencesBackgoundLocation.platformVersion, '42');
  });
}
