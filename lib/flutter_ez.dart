import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

typedef void EzVedioControllerWidgetCreatedCallback(FlutterEzVedioController controller);

class FlutterEzVedioController {
  FlutterEzVedioController._() : _channel = MethodChannel('flutter_ez');

  final MethodChannel _channel;
//  static const MethodChannel _channel =
//      const MethodChannel('flutter_ez');

//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }

//  static Future<Widget> get myPatformView async{
//    final Widget myview = await _channel.invokeMethod('MyUiKitView');
//    return myview;
//  }
  //开始转动方向，//方向，1:左，2：右，4：上，8：下，16：拉近镜头，32：拉远镜头。 镜头如果翻转，那么上下的值会被颠倒
  Future<String> moveCamera(int orientation) async{
    return _channel.invokeMethod('moveCamera',orientation);
  }

//  Future<void> right() async{
//    return _channel.invokeMethod('right');
//  }
//关闭声音
  Future<void> closeSound() async{
    return _channel.invokeMethod('closeSound');
  }
//打开声音
  Future<void> openSound() async{
    return _channel.invokeMethod('openSound');
  }

  //停止转动方向。//方向，1:左，2：右，4：上，8：下，16：拉近镜头，32：拉远镜头。 镜头如果翻转，那么上下的值会被颠倒
  Future<void> stopMove(int orientation) async{
    return _channel.invokeMethod('stopMoveCamera', orientation);
  }

//  //翻转镜头
//  Future<String> rollingoverCamera() async{
//    return await _channel.invokeMethod("rollingoverCamera");
//  }

  //全屏
  Future<void> orientationHorizontal() async{
    return _channel.invokeMethod('orientationHorizontal');
  }

  //竖屏
  Future<void> orientationVertica() async{
    return _channel.invokeMethod('orientationVertical');
  }

  //播放
  Future<void> startPlay(){
    return _channel.invokeMethod('startPlay');
  }

  //停止播放
  Future<void> stopPlay(){
    return _channel.invokeMethod('stopPlay');
  }

  Future<void> releasePlayer(){
    return _channel.invokeMethod('releasePlayer');
  }

}

class VideoViewController extends StatefulWidget {
  const VideoViewController({
    Key key,
    this.width = 1.0,
    this.height = 1.0,
    this.ezVedioControllerWidgetCreatedCallback,
    this.deviceSerial, this.cameraNo,

  }) : super(key: key);

  @override
  _VideoViewControllerState createState() => _VideoViewControllerState();
  final double width;
  final double height;
  final String deviceSerial;
  final int cameraNo;
  final EzVedioControllerWidgetCreatedCallback ezVedioControllerWidgetCreatedCallback;
}

class _VideoViewControllerState extends State<VideoViewController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: UiKitView(
        viewType: 'plugins/flutter_ez',
        creationParams: <String,dynamic>{
          "deviceSerial": widget.deviceSerial,
          "cameraNo":widget.cameraNo,
        },
        onPlatformViewCreated: (id){
          return _onPlatformViewCreated();
        },
        creationParamsCodec: new StandardMessageCodec(),
      ),
    );
  }

  void _onPlatformViewCreated(){
    if(widget.ezVedioControllerWidgetCreatedCallback == null){
      return ;
    }
    widget.ezVedioControllerWidgetCreatedCallback(new FlutterEzVedioController._());
  }
}

