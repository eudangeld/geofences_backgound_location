import 'package:flutter/material.dart';
import 'package:geofences_backgound_location/geofences_backgound_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Geofences.startMonitoring(
        "https://hooks.slack.com/services/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");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bg location - Example App'),
        ),
        body: Center(),
      ),
    );
  }
}
