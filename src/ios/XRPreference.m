//
//  XRPreference.m
//  cordova-demo
//
//  Created by 袁训锐 on 2020/2/20.
//

#import "XRPreference.h"
// 启动服务
#import <AlicloudHAUtil/AlicloudHAProvider.h>
// 崩溃分析
#import <AlicloudCrash/AlicloudCrashProvider.h>
// 性能分析
#import <AlicloudAPM/AlicloudAPMProvider.h>
// 远程日志
#import <AlicloudTLog/AlicloudTlogProvider.h>

typedef struct {
    NSString *appVersion; //
    NSString *channel;
    NSString *nick;
} XRAliEmasParameter;

NSString *const ROOTCONFIGKEY = @"config";
NSString *const PLUGIN_PARAMETER_KEY_APPVERSION = @"appVersion";
NSString *const PLUGIN_PARAMETER_KEY_CHANNEL = @"channel";
NSString *const PLUGIN_PARAMETER_KEY_NICK = @"nick";

#define XRLog(s, ...) NSLog(@"<%s>%@", __FUNCTION__, [NSString stringWithFormat:(s), ## __VA_ARGS__]);
@interface XRPreference ()
@property (nonatomic, assign) XRAliEmasParameter model;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@end
static XRPreference *shareInstance = nil;
@implementation XRPreference

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc]init];
        NSLog(@"###########");
    });
    return shareInstance;
}

#pragma mark - 自定义
/**
 @brief 参数注册
 */
- (void)registerParameterWithAppVersion:(NSString *)appVersion channel:(NSString *)channel nick:(NSString *)nick {
    if (appVersion && channel && nick) {
        _parameter = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                      appVersion, PLUGIN_PARAMETER_KEY_APPVERSION, channel, PLUGIN_PARAMETER_KEY_CHANNEL,
                      nick, PLUGIN_PARAMETER_KEY_NICK, nil];
    }
}

#pragma mark - API

- (void)registerData:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;

    /// 注册parameter
    CDVPluginResult * (^ registerParameterBlock)(CDVInvokedUrlCommand *) = ^(CDVInvokedUrlCommand *command) {
        if (command.arguments.count && command.arguments.count >= 3) {
            NSString *appVersion = [command.arguments objectAtIndex:0];
            NSString *channel = [command.arguments objectAtIndex:1];
            NSString *nick = [command.arguments objectAtIndex:2];
            // 参数注册
            [[XRPreference shareInstance]registerParameterWithAppVersion:appVersion channel:channel nick:nick];
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@", command.arguments]];
        } else {
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%s %@ %@", __FUNCTION__, @"传入的参数不合规", command.arguments]];
        }
    };

    CDVPluginResult *resultForRegisterParameter = registerParameterBlock(command);
    return [self.commandDelegate sendPluginResult:resultForRegisterParameter callbackId:callbackId];
}

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudAPM:(CDVInvokedUrlCommand *)command {
    NSDictionary *parameter = [XRPreference shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudAPMProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 远程日志初始化接口（自动读取appKey、appSecret）
* @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudTlog:(CDVInvokedUrlCommand *)command {
    NSDictionary *parameter = [XRPreference shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudTlogProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 崩溃分析始化接口（自动读取appKey、appSecret）
* @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudCrash:(CDVInvokedUrlCommand *)command {
    NSDictionary *parameter = [XRPreference shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudCrashProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start:(CDVInvokedUrlCommand *)command {
    NSLog(@"%s", __FUNCTION__);
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
                           [AlicloudHAProvider start];
                       });
    }];
}

#pragma mark 自动启动服务
/**
@brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
自动读取appKey、appSecret
只需单独集成此api即可
启动服务需在config.xml中配置，具体参照文档说明
函数会返回失败信息，成功无返回
*/
- (void)autoStartAliyunAnalyticsWithArgs:(CDVInvokedUrlCommand *)command {

    NSString *callbackId = command.callbackId;
    NSString *appVersion = [command.arguments objectAtIndex:0];
    NSString *channel = [command.arguments objectAtIndex:1];
    NSString *nick = [command.arguments objectAtIndex:2];
    NSDictionary *dictPreference = self.commandDelegate.settings;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 性能分析
    BOOL xn = [dictPreference objectForKey:@"alicloudxnserve"] || NO;
    // 崩溃分析
    BOOL crash = [dictPreference objectForKey:@"alicloudcrashserve"] || NO;
    // 远程日志
    BOOL tlog = [dictPreference objectForKey:@"alicloudlogserve"] || NO;
    if (!(xn || crash || tlog)) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%s %@", __FUNCTION__, @"你没有开启任何服务，如有需要，请在config.xml文件中注册^_^"]];
        return [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
    dispatch_group_async(group, queue, ^{
        if (xn) {
            [[AlicloudAPMProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"--------性能分析");
        }
        if (tlog) {
            [[AlicloudTlogProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"--------远程日志");
        }
        if (crash) {
            [[AlicloudCrashProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"--------崩溃分析");
        }
    });

    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            XRLog(@"-------- start");
            [AlicloudHAProvider start];
        });
    });
}

@end
