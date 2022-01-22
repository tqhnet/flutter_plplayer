package com.tqh.plugin_plplayer;

import android.annotation.SuppressLint;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;


import com.pili.pldroid.player.PLOnCompletionListener;
import com.pili.pldroid.player.PLOnErrorListener;
import com.pili.pldroid.player.PLOnInfoListener;
import com.pili.pldroid.player.PLOnPreparedListener;
import com.pili.pldroid.player.widget.PLVideoTextureView;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import kotlin.TypeCastException;
import kotlin.jvm.internal.Intrinsics;

public final class MyFlutterView implements PlatformView, MethodChannel.MethodCallHandler, PLOnErrorListener, PLOnPreparedListener, PLOnCompletionListener, PLOnInfoListener {

    private MethodChannel methodChannel;
    private Context context;
    private double width, heigth;
    boolean isFill;
    String url = "";

    //七牛播放
    PLVideoTextureView player;
    RelativeLayout layout;


    @NotNull
    public View getView() {
        return layout;
    }

    public void dispose() {
        this.methodChannel.setMethodCallHandler((MethodChannel.MethodCallHandler) null);
    }

    public void onMethodCall(@NotNull MethodCall call, @NotNull MethodChannel.Result result) {
        Intrinsics.checkParameterIsNotNull(call, "call");
        Intrinsics.checkParameterIsNotNull(result, "result");
        Log.e("七牛", "七牛====method==" + call.method);
        if (Intrinsics.areEqual(call.method, "setText")) {
//            String name = (String) call.argument("name");
//            Integer age = (Integer) call.argument("age");
//            textView.setText("hello," + name + ",年龄：" + age);
        } else if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("create")) {

        } else if (call.method.equals("playUrl")) {
          String urlNew = (String) call.arguments;
            if (url.isEmpty()||!url.equals(urlNew+"")){
                url = (String) call.arguments;
                player.setVideoPath(url);
            }
            player.start();
        } else if (call.method.equals("stop")) {
            player.pause();
        } else if (call.method.equals("resume")) {
            String urlNew = (String) call.arguments;
            if (url.isEmpty()||!url.equals(urlNew+"")){
                url = (String) call.arguments;
                player.setVideoPath(url);
            }
            player.start();
        } else if (call.method.equals("pause")) {
            player.pause();
        } else if (call.method.equals("isFull")) {
            isFill = (boolean) call.arguments;

        }  else if (call.method.equals("dispose")) {
            player.pause();
            player.stopPlayback();
        } else {
            result.notImplemented();
        }

    }

    public MyFlutterView(@NotNull Context context, @NotNull BinaryMessenger messenger, int viewId, @Nullable Map args) {
        super();
        Log.e("七牛", "七牛====method==" + viewId);
        this.methodChannel = new MethodChannel(messenger, "com.tqhnet.xj_pl_player_view_1");
        this.methodChannel.setMethodCallHandler(this);
        this.context = context;
        Intrinsics.checkParameterIsNotNull(context, "context");
        Intrinsics.checkParameterIsNotNull(messenger, "messenger");
        if (args != null) {
            //var10000.setText((CharSequence) ((String) var10001));
//            width = (double) args.get("width");
//            heigth = (double) args.get("height");
            isFill = (boolean) args.get("isFull");
            url= (String) args.get("url");
        }
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        heigth = dm.heightPixels;
        width = dm.widthPixels;
        layout=new RelativeLayout(context);
        layout.setGravity(Gravity.CENTER);
       // layout.setLayoutParams(new ViewGroup.LayoutParams((int)width, (int) ( width*0.6)));
       // player = VideoManange.getInstance(context);
        player = new PLVideoTextureView(context);
        player.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.MATCH_PARENT));
        player.setOnErrorListener(this);
        player.setOnPreparedListener(this);
        player.setOnCompletionListener(this);
        player.setOnInfoListener(this);
        Log.e("七牛", "七牛====url==" + url);
        if (!url.isEmpty()){
            player.setVideoPath(url);
            player.start();
        }
        layout.addView(player);
    }

    @Override
    public void onCompletion() {
        methodChannel.invokeMethod("state", 10);
    }

    @Override
    public boolean onError(int i) {
        Log.e("七牛", "错误码:" + i);
        //ToastUtil.show(getContext(), getContext().getString(R.string.wrong));
        switch (i) {
            //无效的 URL
            case PLOnErrorListener.ERROR_CODE_OPEN_FAILED:
                //Toast.makeText(context,"无效的 URL",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "无效的 URL");
                break;
            case PLOnErrorListener.ERROR_CODE_SEEK_FAILED:
                //	拖动失败
                //Toast.makeText(context,"拖动失败",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "拖动失败");
                break;
            //	预加载失败
            case PLOnErrorListener.ERROR_CODE_CACHE_FAILED:
                // Toast.makeText(context,"预加载失败",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "播放器已被销毁");
                break;
            //播放器已被销毁
            case PLOnErrorListener.ERROR_CODE_PLAYER_DESTROYED:
                //Toast.makeText(context,"播放器已被销毁",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "");
                break;
            //so 库版本不匹配，需要升级
            case PLOnErrorListener.ERROR_CODE_PLAYER_VERSION_NOT_MATCH:
                //Toast.makeText(context,"so 库版本不匹配，需要升级",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "so 库版本不匹配，需要升级");
                break;
            //	网络异常
            case PLOnErrorListener.ERROR_CODE_IO_ERROR:
                //Toast.makeText(context,"网络异常",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "网络异常");
                break;
            //AudioTrack 初始化失败，可能无法播放音频
            case PLOnErrorListener.ERROR_CODE_PLAYER_CREATE_AUDIO_FAILED:
                // Toast.makeText(context,"AudioTrack初始化失败，可能无法播放音频",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "AudioTrack初始化失败，可能无法播放音频");
                break;
            case PLOnErrorListener.ERROR_CODE_HW_DECODE_FAILURE:
                //Toast.makeText(context,"硬解码失败",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "硬解码失败");
                break;
            //未知错误
            case PLOnErrorListener.MEDIA_ERROR_UNKNOWN:
                // Toast.makeText(context,"播放器未知错误",Toast.LENGTH_SHORT).show();
                methodChannel.invokeMethod("error", "播放器未知错误");
                break;
            default:

        }
        return false;
    }

    @Override
    public void onInfo(int what, int i1) {
        Log.e("七牛", "onInfo:" + what);
        methodChannel.invokeMethod("state", what);
        switch (what) {
            case MEDIA_INFO_VIDEO_RENDERING_START:

                break;
            case MEDIA_INFO_BUFFERING_START:

                break;
            case MEDIA_INFO_BUFFERING_END:

                break;
            case MEDIA_INFO_UNKNOWN:

            default:
                break;
        }
    }


    @Override
    public void onPrepared(int i) {
        methodChannel.invokeMethod("state", i);
    }
}