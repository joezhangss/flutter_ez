import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ez/flutter_ez.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
//    initPlatformState();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeRight,
//    ]);
//    controller.initEZOpen();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FlutterEz.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
//  }

  double vedioWidth = 100.0;
  double vedioHeight = 200.0;
  FlutterEzVedioController controller;

  void _onflutterEzVedioControllerCreated(FlutterEzVedioController _controller){
    controller = _controller;
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Plugin example app'),
//        ),
        body: ListView(
          children: <Widget>[
            VideoViewController(
              width: vedioWidth,
              height: vedioHeight,
              ezVedioControllerWidgetCreatedCallback: _onflutterEzVedioControllerCreated,
            ),
            IconButton(icon: Icon(Icons.code), onPressed: (){
              controller.orientationHorizontal();
              setState(() {
                vedioHeight = 300.0;
              });
            }),
            IconButton(icon: Icon(Icons.chevron_left), onPressed: (){
//              FlutterEzVedioController.initEZOpen();
              controller.orientationVertica();
              setState(() {
                vedioHeight = 200.0;
              });
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//    ]);
    super.dispose();
  }
}
