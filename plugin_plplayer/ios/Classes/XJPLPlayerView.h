//
//  XJPLPlayerView.h
//  plugin_plplayer
//
//  Created by xj_mac on 2020/12/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <PLPlayerKit/PLPlayerKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJPLPlayerView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args messager:(id<FlutterBinaryMessenger>)messager;

@end

@interface XJPLPlayerManager : NSObject

+ (instancetype)shareManager;
@property (nonatomic,strong) PLPlayer *player;
@property (nonatomic,copy) void(^stateBlock)(int state,NSInteger videoId);
@property (nonatomic,copy) void(^errorBlock)(NSString *error,NSInteger videoId);

- (void)addSuperView:(UIView *)view videoId:(NSInteger)videoId;
- (void)stopWithId:(NSInteger)Id;   // 停止
- (void)pauseWithId:(NSInteger)Id ;  // 暂停
- (void)resumeWithId:(NSInteger)Id; // 恢复播放
- (void)playWithUrl:(NSString *)url videoId:(NSInteger)videoId;
- (void)playSpped:(float)playSpeed;//播放速率

@end

NS_ASSUME_NONNULL_END
