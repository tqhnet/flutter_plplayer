import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
typedef XJPLPlayerControlStateCallback = void Function(int state);
typedef XJPLPlayerControlErrorCallback = void Function(String state);
class XJPLVideoPlayerControl {

  XJPLVideoPlayerControl();
  XJPLVideoPlayerControl.videoId({this.videoId = 1});

  int videoId = 1;

  VoidCallback onLoadBlock;
  int state = 0;
  bool isFull = false;

  bool isPause = false;

  /// 状态：0未知，1正在准备，2播放准备，3播放准备完成，4无缓存数据，5正在播放，6暂停，7停止，8错误，9自动重连，10播放完成
  XJPLPlayerControlStateCallback onStateListen;
  XJPLPlayerControlErrorCallback onErrorListen;

  MethodChannel channel;
  void init(int viewId) {
    channel = MethodChannel('com.tqhnet.xj_pl_player_view_$viewId');
    channel.setMethodCallHandler(platformCallHandler);
    channel.invokeListMethod('create');
    onLoad();
  }

  void onLoad(){
    if(onLoadBlock!= null){
      onLoadBlock();
    }
  }

  void playUrl(String url) {
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('playUrl',url);
    isPause = false;
  }

  void stop() {
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('stop');
    isPause = false;
  }

  void resume(String url){
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('resume',url);
    isPause = false;
  }

  void pause(){
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('pause');
    isPause = true;
  }

  void setFull(bool full){
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('isFull',full);
  }

  /// 设置播放速度默认1，值为0.2-32
  void setPlaySpeed(double playSpeed) {
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    channel.invokeListMethod('playSpeed',playSpeed);
  }

  //添加销毁
  void dispose() {
    if(channel == null){
      print('七牛通信没有初始化');
      return;
    }
    stop();
    channel.invokeListMethod('dispose');
    isPause = false;
  }

  /// 收到回调
  Future<dynamic> platformCallHandler(MethodCall call) async {
    print(call.method);
    if(call.method == 'state'){
      state = call.arguments;
      if(onStateListen != null){
        onStateListen(state);
      }
    }else if(call.method == 'error'){
      if(onErrorListen != null){
        onErrorListen(call.arguments);
      }
    }
  }
}
