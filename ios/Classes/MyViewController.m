//
//  MyViewController.m
//  flutter_ez
//
//  Created by dengxiao on 2019/8/27.
//

#import "MyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <EZOpenSDKFramework/EZOpenSDKFramework.h>


@interface MyViewController ()<EZPlayerDelegate>

@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) EZPlayer *mPreviewPlayer;//预览播放器
@property (nonatomic, strong) NSString *deviceSerial;//设备序列号
@property (nonatomic, assign) NSInteger cameraNo;//通道号
//@property (nonatomic, strong) EZDeviceInfo *deviceInfo;//设备信息


@end

@implementation MyViewController
{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
//    UIView *_myView;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
{

    NSDictionary *dic = args;
    self.deviceSerial = dic[@"deviceSerial"];
    self.cameraNo = [dic[@"cameraNo"] integerValue];
    if([super init]){
//        NSDictionary *dic = args;
        self.myView = [[UIView alloc] init];//WithFrame:CGRectMake(0,0, 0, 0)
        self.myView.backgroundColor = [UIColor blackColor];
//        [self startPlay];
        
//        [EZOpenSDK getDeviceInfo:self.deviceSerial completion:^(EZDeviceInfo *deviceInfo, NSError *error) {
//            self.deviceInfo = deviceInfo;
//        }];
        
        _viewId = viewId;
        NSString* channelName = @"flutter_ez";//[NSString stringWithFormat:@"flutter_ez", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
    }
    
    return self;
}

- (UIView *)view
{
    return _myView;
}


- (void)startPlay
{
//    NSLog(@"序列号：%@",self.deviceSerial );
//    [EZOpenSDK setVideoLevel:self.deviceSerial cameraNo:self.cameraNo videoLevel:EZVideoLevelLow completion:^(NSError *error) {
//        NSLog(@"切换视频质量。。。");
//    }];
    
//    if(self.deviceInfo.isEncrypt){
//        NSLog(@"视频已加密。。");
//    }else{
//        NSLog(@"视频未加密。。");
//    }
    
    if (self.mPreviewPlayer)
    {
        [self.mPreviewPlayer startRealPlay];
        return;
    }

    self.mPreviewPlayer = [EZPlayer createPlayerWithDeviceSerial:self.deviceSerial cameraNo: self.cameraNo];// 172891595
    [self.mPreviewPlayer setPlayerView:self.myView];
    self.mPreviewPlayer.delegate = self;

    [self.mPreviewPlayer startRealPlay];
}

//停止播放
- (void)stopPlay
{
    if (self.mPreviewPlayer)
    {
        [self.mPreviewPlayer stopRealPlay];
        return;
    }
    
}

//关闭声音
- (void)closeSound
{
    if (self.mPreviewPlayer)
    {
        [self.mPreviewPlayer closeSound];
        return;
    }
}

//打开声音
- (void)openSound
{
    if (self.mPreviewPlayer)
    {
        [self.mPreviewPlayer openSound];
        return;
    }
    
    
}


////翻转镜像
//- (void)rollCameraWithResult:(FlutterResult) result{
//    [EZOpenSDK controlVideoFlip:self.deviceSerial cameraNo:self.cameraNo command:EZDisplayCommandCenter result:^(NSError *error) {
//        if (!error) {
////            hud.labelText = [NSString stringWithFormat:@"翻转成功"];
//            NSLog(@"翻转成功.");
//            result(@"success");
//        }else {
////            hud.labelText = [NSString stringWithFormat:@"翻转失败"];
//             NSLog(@"翻转失败.");
//             result(@"falied");
//        }
//    }];
//}

//移动摄像头//方向，0:左，1：右，2：上，3：下，4：拉近镜头，5：拉远镜头
- (void)moveCameraWithOrientation:(NSInteger )ori andMoveState:(NSInteger) state andResult:(FlutterResult) result
{
    NSInteger comm = 0;
    switch (ori) {
        case 0:
            comm = EZPTZCommandLeft;
            break;
        case 1:
            comm = EZPTZCommandUp;
            break;
        case 2:
            comm = EZPTZCommandRight;
            break;
        case 3:
            comm = EZPTZCommandDown;
            break;
        default:
            break;
    }
    [EZOpenSDK controlPTZ:self.deviceSerial cameraNo:self.cameraNo command:comm action:state speed:1 result:^(NSError *error) {
//        NSLog(@"description=%@",error.userInfo[@"NSLocalizedDescription"]);
//        NSLog(@"error.domain==%ld",error.code);
//        self->moveResultMsg =error.userInfo[@"NSLocalizedDescription"];
//        NSLog(@"moveResultMsg==%@",self->moveResultMsg);
        result(error.userInfo[@"NSLocalizedDescription"]);
//        self->moveResultMsg =error.userInfo[@"NSLocalizedDescription"];
    }];
}



-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    /*******************移动摄像头 start******************************/
    if ([[call method] isEqualToString:@"moveCamera"]) {
        [self moveCameraWithOrientation:[call.arguments integerValue] andMoveState:EZPTZActionStart andResult:result];
//        NSLog(@"返回消息：%@",moveResultMsg);
//        result(moveResultMsg);
    }
    else if([[call method] isEqualToString: @"stopMoveCamera"]){

        [self moveCameraWithOrientation:[call.arguments integerValue] andMoveState:EZPTZActionStop andResult:result];
    }
//    else if([[call method] isEqualToString: @"rollingoverCamera"]){
//        //翻转摄像头
//        [self rollCameraWithResult:result];
//    }
    /*******************移动摄像头 end******************************/

    else if([call.method isEqualToString:@"openSound"])
    {
        //暂停播放
        [self openSound];
    }
    else if([call.method isEqualToString:@"closeSound"])
    {
        //暂停播放
        [self closeSound];
    }
    //播放
    else if([call.method isEqualToString:@"startPlay"])
    {
        [self startPlay];
    }
    else if([call.method isEqualToString:@"stopPlay"])
    {
        //停止播放
        [self stopPlay];
    }
    //
    
    else if ([[call method] isEqualToString:@"orientationHorizontal"])
    {
//        NSLog(@"222设置横屏。。。");
       //设置横屏
       [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
       /*
       NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
               [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];

               NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
               [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
               result(nil);*/
    }
    else if ([[call method] isEqualToString:@"orientationVertical"])
    {
        NSLog(@"设置竖屏。。。");
      //设置竖屏
      NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
      [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];

      NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
      [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
      result(nil);
    }
    else if([[call method] isEqualToString:@"releasePlayer"])
    {
        NSLog(@"释放播放器。。。");
//        [self stopPlay];
//        [self closeSound];
        [EZOpenSDK releasePlayer:self.mPreviewPlayer];
//        self.mPreviewPlayer = nil;
    }
    else
    {
       result(FlutterMethodNotImplemented);
    }
}

@end
