import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_plplayer/xj_pl_player_control.dart';

/// 播放器视图
class XJPLPlayerFlutterView extends StatefulWidget {
  final XJPLVideoPlayerControl controller;
  final bool isFull;
  final String url;
  final int videoId;
  final double height;
  const XJPLPlayerFlutterView({Key key, this.controller, this.isFull = false,this.url,this.videoId = 1,this.height = 200})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _XJPLPlayerFlutterViewState();
  }
}

class _XJPLPlayerFlutterViewState extends State<XJPLPlayerFlutterView> {
  @override
  Widget build(BuildContext context) {
    return _platformView();
  }

  Widget _platformView() {
    print('顺序3');
    if (defaultTargetPlatform == TargetPlatform.android) {
      final size = MediaQuery.of(context).size;
      return AndroidView(
        viewType: 'plugins.flutter.io/xj_pl_player_view',
        onPlatformViewCreated: (viewId) {
          //widget.controller.init(1);
          //widget.controller.init(viewId);
          //widget.controller.onLoad();
          print(viewId.toString() + '~~~');
        },
        creationParams: {
          'isFull': widget.isFull,
          'text': 'Flutter传给androidTextView的参数',
          'width': widget.isFull ? size.height : size.width,
          'height': widget.isFull ? size.width : 200, //前置后置摄像
          'url':widget.url
        }, //向iOS传递
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final size = MediaQuery.of(context).size;
      var videoId = widget.videoId;
      return UiKitView(
        viewType: 'plugins.flutter.io/xj_pl_player_view',
        onPlatformViewCreated: (viewId) {
          if(widget.controller != null){
            widget.controller.init(videoId);
          }

          print(viewId.toString() + '~~~');
        },
        creationParams: {
          'isFull': widget.isFull,
          'text': 'Flutter传给IOSTextView的参数',
          'width': widget.isFull ? size.height : size.width,
          'height': widget.isFull ? size.width : widget.height, //前置后置摄像
          'url':widget.url,
          'videoId':videoId
        }, //向iOS传递初始化参数
        creationParamsCodec:
            StandardMessageCodec(), //将 creationParams 编码后再发送给平台侧
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
