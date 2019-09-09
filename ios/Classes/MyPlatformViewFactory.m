//
//  MyPlatformViewFactory.m
//  flutter_ez
//
//  Created by dengxiao on 2019/8/27.
//

#import "MyPlatformViewFactory.h"
#import "MyViewController.h"

@implementation MyPlatformViewFactory
{
    NSObject<FlutterBinaryMessenger> *_messenger;
}

- (instancetype)initWithMessenger: (NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if(self) _messenger = messenger;
    
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame: (CGRect)frame viewIdentifier: (int64_t)viewId arguments:(id)args
{
    MyViewController *tmpcontroller = [[MyViewController alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return tmpcontroller;
}


@end
