# flutter_plplayer
七牛云播放器flutter版本的插件

目前只支持iOS，后续完善demo

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_plplayer/plugin_plplayer.dart';
import 'package:plugin_plplayer/xj_pl_player_control.dart';
import 'package:plugin_plplayer/xj_pl_player_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  XJPLVideoPlayerControl _controller = XJPLVideoPlayerControl();
  @override
  void initState() {
    super.initState();
    _controller.onStateListen = (state){
      print('state = '+state.toString());
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: [
            Row(children: [
              MaterialButton(onPressed: (){
                _controller.playUrl('http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4');
              },child: new Text('播放'),),
              MaterialButton(onPressed: (){
                if(_controller.isPause){
                  _controller.resume('http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4');
                }else {
                  _controller.pause();
                }
              },child: new Text('暂停恢复'),),
              MaterialButton(onPressed: (){
                _controller.pause();
              },child: new Text('停止'),),
              MaterialButton(onPressed: (){
                _controller.setFull(true);
              },child: new Text('全屏'),)
            ],),
            Container(child: XJPLPlayerFlutterView(controller: _controller),height: 200,width: 414,color: Colors.black),
          ],),
        ),
      ),
    );
  }
}

```

