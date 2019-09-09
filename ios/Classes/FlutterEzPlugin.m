#import "FlutterEzPlugin.h"
#import "MyPlatformViewFactory.h"


@implementation FlutterEzPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  FlutterMethodChannel* channel = [FlutterMethodChannel
//      methodChannelWithName:@"flutter_ez"
//            binaryMessenger:[registrar messenger]];
//  FlutterEzPlugin* instance = [[FlutterEzPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
    
    [registrar registerViewFactory:[[MyPlatformViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"plugins/flutter_ez"];
}

//- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//  if ([@"getPlatformVersion" isEqualToString:call.method]) {
//    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//  }
//  else if([@"MyUiKitView" isEqualToString:call.method]){
//
//
////      result(myView);
//  }
//  else {
//    result(FlutterMethodNotImplemented);
//  }
//}



@end
