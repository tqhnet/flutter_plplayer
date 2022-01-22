//
//  XJPLPlayerFactory.h
//  plugin_plplayer
//
//  Created by xj_mac on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface XJPLPlayerFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessager:(id<FlutterBinaryMessenger>)messager;
@end

NS_ASSUME_NONNULL_END
