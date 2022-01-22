package com.tqh.plugin_plplayer;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.platform.PlatformViewRegistry;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.Intrinsics;

/** PluginPlplayerPlugin */
public class PluginPlplayerPlugin implements FlutterPlugin {
  public  PluginPlplayerPlugin.Companion Companion = new Companion();

  public void onAttachedToEngine(@NotNull FlutterPluginBinding binding) {
    Intrinsics.checkParameterIsNotNull(binding, "binding");
    BinaryMessenger var10000 = binding.getBinaryMessenger();
    Intrinsics.checkExpressionValueIsNotNull(var10000, "binding.binaryMessenger");
    BinaryMessenger messenger = var10000;
    binding.getPlatformViewRegistry().registerViewFactory("plugins.flutter.io/xj_pl_player_view", (PlatformViewFactory)(new MyFlutterViewFactory(messenger)));
  }

  public void onDetachedFromEngine(@NotNull FlutterPluginBinding binding) {
    Intrinsics.checkParameterIsNotNull(binding, "binding");
  }

  @JvmStatic
  public  void registerWith(@NotNull PluginRegistry.Registrar registrar) {
    Companion.registerWith(registrar);
  }


  public  class Companion {
    @JvmStatic
    public  void registerWith(@NotNull PluginRegistry.Registrar registrar) {
      Intrinsics.checkParameterIsNotNull(registrar, "registrar");
      PlatformViewRegistry var10000 = registrar.platformViewRegistry();
      BinaryMessenger var10004 = registrar.messenger();
      Intrinsics.checkExpressionValueIsNotNull(var10004, "registrar.messenger()");
      var10000.registerViewFactory("plugins.flutter.io/xj_pl_player_view", (PlatformViewFactory)(new MyFlutterViewFactory(var10004)));
    }
  }
}
