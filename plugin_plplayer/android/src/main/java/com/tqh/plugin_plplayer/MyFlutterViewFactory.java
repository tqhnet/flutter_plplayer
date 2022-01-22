package com.tqh.plugin_plplayer;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import kotlin.jvm.internal.Intrinsics;

public  class MyFlutterViewFactory extends PlatformViewFactory {

    private  BinaryMessenger messenger;


    public PlatformView create(Context context, int viewId, Object args) {
        Intrinsics.checkParameterIsNotNull(context, "context");
        MyFlutterView flutterView = new MyFlutterView(context, this.messenger, viewId, (Map)args);
        return (PlatformView)flutterView;
    }

    public BinaryMessenger getMessenger() {
        return this.messenger;
    }

    public MyFlutterViewFactory( BinaryMessenger messenger) {
        super((MessageCodec) StandardMessageCodec.INSTANCE);
        Intrinsics.checkParameterIsNotNull(messenger, "messenger");
        this.messenger = messenger;
    }
}

