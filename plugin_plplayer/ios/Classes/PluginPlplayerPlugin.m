#import "PluginPlplayerPlugin.h"
#import "XJPLPlayerFactory.h"

@implementation PluginPlplayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugin_plplayer"
            binaryMessenger:[registrar messenger]];
  PluginPlplayerPlugin* instance = [[PluginPlplayerPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    
    XJPLPlayerFactory *factory = [[XJPLPlayerFactory alloc]initWithMessager:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"plugins.flutter.io/xj_pl_player_view"];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
