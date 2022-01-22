//
//  XJPLPlayerView.m
//  plugin_plplayer
//
//  Created by xj_mac on 2020/12/24.
//

#import "XJPLPlayerView.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface XJPLPlayerView()<PLPlayerDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) CGSize contentSize;
@property (nonatomic,assign) BOOL isBackVideo; //是否是后置视频
@property (nonatomic,strong) FlutterMethodChannel *methodChannel;
@property (nonatomic,assign) BOOL isFull; //是否是全屏
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIView *playerView;
@property (nonatomic,assign) NSInteger videoId; //是否是全屏
@end

@implementation XJPLPlayerView

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args messager:(id<FlutterBinaryMessenger>)messager {
    self = [super init];
    if (self) {
        NSInteger videoId = 1;
        if ([args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *param = args;
            CGFloat width =  [param[@"width"]floatValue];
            CGFloat height =  [param[@"height"]floatValue];
            self.isBackVideo = [param[@"backVideo"]boolValue];
            self.contentSize = CGSizeMake(width, height);
            self.isFull = [param[@"isFull"]boolValue];
            self.url = [NSString stringWithFormat:@"%@",param[@"url"]];
            videoId = [param[@"videoId"] integerValue];
        }
        self.videoId = videoId;
        //当创建下一个视图的时候就会将下个视图作为主视图而造成之前视图显示不了
//        NSString *name = [NSString stringWithFormat:@"com.tqhnet.XJDPVideoView_before_%lld",viewId];
        NSLog(@"---++--%@",NSStringFromCGRect(frame));
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width,self.contentSize.height)];
        view.backgroundColor = [UIColor blackColor];
        self.playerView = view;
        self.coverView.frame = view.frame;
        [self.contentView addSubview:view];
       
        NSLog(@"---++--%@",NSStringFromCGRect(view.frame));
        // 初始化 PLPlayerOption 对象
        //http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4
        NSLog(@"videold = %ld",videoId);
        __weak typeof(self) myself = self;
        [[XJPLPlayerManager shareManager] addSuperView:view videoId:videoId];
        if(!myself.isFull){//因为
            [self.contentView addSubview:self.coverView];
            myself.coverView.hidden = YES;
            if(!myself.isFull){
                [[XJPLPlayerManager shareManager]setStateBlock:^(int state,NSInteger remoteVideId) {
                    NSLog(@"监听播放状态%d",state);
                    if(remoteVideId == self.videoId){
                        ///做处理
                        if(state == 1 || state == 2){
                            myself.coverView.hidden = NO;
                        }else {
                            myself.coverView.hidden = YES;
                        }
                        [myself.methodChannel invokeMethod:@"state" arguments:@(state)];
                    }
                }];
                [[XJPLPlayerManager shareManager]setErrorBlock:^(NSString * _Nonnull error,NSInteger remoteVideId) {
                    if(remoteVideId == self.videoId){
                        [myself.methodChannel invokeMethod:@"error" arguments:@""];
                    }
                }];
            }
            /// 因为是同一个id
            self.methodChannel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"com.tqhnet.xj_pl_player_view_%ld",videoId] binaryMessenger:messager];
            [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
                if ([call.method isEqualToString:@"playUrl"]) {
                    
                    [[XJPLPlayerManager shareManager]playWithUrl:call.arguments videoId:videoId];
                }else if([call.method isEqualToString:@"stop"]){
                    [[XJPLPlayerManager shareManager] stopWithId:videoId];
                }else if([call.method isEqualToString:@"pause"]){
                    //pause
                    [[XJPLPlayerManager shareManager] pauseWithId:videoId];
                }else if([call.method isEqualToString:@"resume"]){
                    //pause
                    [[XJPLPlayerManager shareManager] resumeWithId:videoId];
                }
                else if([call.method isEqualToString:@"playSpeed"]){
                    double playSpeed = [[NSString stringWithFormat:@"%@",call.arguments] doubleValue];
                    [[XJPLPlayerManager shareManager] playSpped:playSpeed];
                }
                else if([call.method isEqualToString:@"create"]){
                    
                }else if([call.method isEqualToString:@"isFull"]){
                    [[XJPLPlayerManager shareManager] addSuperView:view videoId:videoId];
                };
            }];
        }
    }
    return self;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

#pragma mark - private

- (UIView *)view {
    return self.contentView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (void)dealloc {
//    if(!self.isFull){
//        [[XJPLPlayerManager shareManager] stopWithId:self.videoId];
//    }
    NSLog(@"【七牛播放器销毁了】");
}

@end

@interface XJPLPlayerManager()<PLPlayerDelegate>
@property (nonatomic,strong) PLPlayer *player2;

@end

@implementation XJPLPlayerManager

+ (instancetype)shareManager {
    static XJPLPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XJPLPlayerManager alloc]init];
    });
    return manager;
}

- (PLPlayer *)player {
    if (!_player) {
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        // 更改需要修改的 option 属性键所对应的值
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [option setOptionValue:@300 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        _player = [PLPlayer playerWithURL:nil option:option];
        _player.delegate = self;
    }
    return _player;
}

- (PLPlayer *)player2 {
    if (!_player2) {
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        // 更改需要修改的 option 属性键所对应的值
        [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
        [option setOptionValue:@300 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
        [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
        [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        _player2 = [PLPlayer playerWithURL:nil option:option];
        _player2.delegate = self;
    }
    return _player2;
}

- (void)stopWithId:(NSInteger)Id {
    if (Id == 1) {
        [self.player stop];
    }else {
        [self.player2 stop];
    }
}

- (void)pauseWithId:(NSInteger)Id {
    if (Id == 1) {
        [self.player pause];
    }else {
        [self.player2 pause];
    }
   
}

- (void)resumeWithId:(NSInteger)Id {
    if (Id == 1) {
        [self.player play];
    }else {
        [self.player2 play];
    }
}

/**
 变速播放，范围是 0.2-32，默认是 1.0
 
 @warning 该属性仅对点播有效
 
 @since v3.0.0
 */
- (void)playSpped:(float)playSpeed {
    NSLog(@"七牛播放速率%f",playSpeed);
    self.player.playSpeed = playSpeed;
}

- (void)playWithUrl:(NSString *)url videoId:(NSInteger)videoId {
    
    if(videoId == 1){
        [self.player playWithURL:[NSURL URLWithString:url] sameSource:NO];
    }else {
        [self.player2 playWithURL:[NSURL URLWithString:url] sameSource:NO];
    }
}

- (void)createPlayer:(UIView *)view isFull:(BOOL)isFull videoId:(NSInteger)videoId {
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    // 更改需要修改的 option 属性键所对应的值
    [option setOptionValue:@2000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [option setOptionValue:@300 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
    //初始化不创建，渲染完成后创建
    // 初始化 PLPlayer
    if(videoId == 1){
        self.player = [PLPlayer playerWithURL:nil option:option];
        // 设定代理 (optional)
        self.player.delegate = self;
        //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    }else {
        self.player2 = [PLPlayer playerWithURL:nil option:option];
        // 设定代理 (optional)
        self.player2.delegate = self;
        //获取视频输出视图并添加为到当前 UIView 对象的 Subview
    }
}

- (void)addSuperView:(UIView *)view videoId:(NSInteger)videoId {
    if(videoId == 1){
        [view addSubview:self.player.playerView];
        self.player.playerView.frame = view.bounds;
    }else {
        [view addSubview:self.player2.playerView];
        self.player2.playerView.frame = view.bounds;
    }
    
}

#pragma mark - <PLPlayerDelegate>

// 实现 <PLPlayerDelegate> 来控制流状态的变更
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    // 这里会返回流的各种状态，你可以根据状态做 UI 定制及各类其他业务操作
    // 除了 Error 状态，其他状态都会回调这个方法
  // 开始播放，当连接成功后，将收到第一个 PLPlayerStatusCaching 状态
  // 第一帧渲染后，将收到第一个 PLPlayerStatusPlaying 状态
  // 播放过程中出现卡顿时，将收到 PLPlayerStatusCaching 状态
  // 卡顿结束后，将收到 PLPlayerStatusPlaying 状态
    NSLog(@"【七牛播放状态】:%ld",state);
//    [self.methodChannel invokeMethod:@"state" arguments:@(state)];
    NSInteger videoId = 2;
    if (player == self.player) {
        videoId = 1;
    }
    
    if(self.stateBlock){
        self.stateBlock((int)state,videoId);
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    // 当发生错误，停止播放时，会回调这个方法
    NSLog(@"【七牛播放报错】:%@",error);
//    [self.methodChannel invokeMethod:@"error" arguments:@""];
    NSInteger videoId = 2;
    if (player == self.player) {
        videoId = 1;
    }
    if(self.errorBlock){
        self.errorBlock(error.localizedDescription,videoId);
    }
}

- (void)player:(nonnull PLPlayer *)player codecError:(nonnull NSError *)error {
  // 当解码器发生错误时，会回调这个方法
  // 当 videotoolbox 硬解初始化或解码出错时
  // error.code 值为 PLPlayerErrorHWCodecInitFailed/PLPlayerErrorHWDecodeFailed
  // 播发器也将自动切换成软解，继续播放
    NSLog(@"【七牛解码报错】:%@",error);
    NSInteger videoId = 2;
    if (player == self.player) {
        videoId = 1;
    }
    if(self.errorBlock){
        self.errorBlock(error.localizedDescription,videoId);
    }
}

@end
