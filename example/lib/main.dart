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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BG Locations'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text('Request location'),
                onPressed: () => Geofences.initLocation,
              )
            ],
          ),
        ),
      ),
    );
  }
}
