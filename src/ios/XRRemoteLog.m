//
//  XRRemoteLog.m
//  cordova_demo
//
//  Created by 袁训锐 on 2020/2/28.
//

#import "XRRemoteLog.h"
// 获取 远程日志
#import <TRemoteDebugger/TLogBiz.h>
#import <TRemoteDebugger/TLogFactory.h>

@implementation XRRemoteLog

- (instancetype)init{
    self = [super init];
    return self;
}
- (TLogBiz *)getLogFactoryWithModuleName:(NSString *)name{
    TLogBiz *log = [TLogFactory createTLogForModuleName:name];
    return log;
}
- (void)error:(CDVInvokedUrlCommand *)command{
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log error:message];
}
- (void)warn:(CDVInvokedUrlCommand *)command{
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log error:message];
}
- (void)debug:(CDVInvokedUrlCommand *)command{
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log error:message];
}
- (void)info:(CDVInvokedUrlCommand *)command{
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log error:message];
}
@end
