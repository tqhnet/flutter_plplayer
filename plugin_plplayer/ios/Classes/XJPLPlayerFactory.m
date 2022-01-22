//
//  XJPLPlayerFactory.m
//  plugin_plplayer
//
//  Created by xj_mac on 2020/12/24.
//

#import "XJPLPlayerFactory.h"
#import "XJPLPlayerView.h"
@interface XJPLPlayerFactory ()

@property (nonatomic,weak)  id <FlutterBinaryMessenger> messager;

@end

@implementation XJPLPlayerFactory


- (instancetype)initWithMessager:(id<FlutterBinaryMessenger>)messager {
    self = [super init];
    if (self) {
        self.messager = messager;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[XJPLPlayerView alloc]initWithFrame:frame viewIdentifier:viewId arguments:args messager:self.messager];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
