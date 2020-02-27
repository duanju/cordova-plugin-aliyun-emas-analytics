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
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:12];
    CDVPluginResult * (^ registerPlistBlock)(void) = ^{
        /// 注册plist
        NSArray *deploymentConfigKeys = @[@"emas.appKey", @"emas.appSecret", @"emas.bundleId"];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AliyunEmasServices-Info" ofType:@"plist"];
        NSMutableDictionary *rootDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        NSDictionary *dictPreference = ((CDVViewController *)self.viewController).settings;

        if (rootDict && rootDict[ROOTCONFIGKEY]) {
            NSMutableDictionary *rootConfigDict = [[NSMutableDictionary alloc]initWithDictionary:rootDict[ROOTCONFIGKEY]];
            for (NSString *key in deploymentConfigKeys) {
                NSString *tempkey = [[key stringByReplacingOccurrencesOfString:@"." withString:@""]lowercaseString];
                NSString *value = dictPreference[tempkey];
                if (value) {
                    [rootConfigDict setValue:value forKey:key];
                    [resultDict setValue:value forKey:key];
        #if DEBUG
                    XRLog(@"%@  %@", key, value);
        #endif
                } else {
                    return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"config.xml中未配置:%@", key]];
                }
            }
            [rootDict setObject:rootConfigDict forKey:ROOTCONFIGKEY];
            NSFileManager *fileMger = [NSFileManager defaultManager];
            //如果文件路径存在的话
            BOOL isExist = [fileMger fileExistsAtPath:path];
            if (isExist) {
                NSError *err;
                [fileMger removeItemAtPath:path error:&err];
                [rootDict writeToFile:path atomically:YES];
            }
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        } else {
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", @"未找到AliyunEmasServices-Info.plist文件，可直接从阿里平台下载并导入到工程根目录，届时无需调用该API"]];
        }
    };

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
    CDVPluginResult *resultForRegisterPlist = registerPlistBlock();
    if (!([resultForRegisterPlist.status unsignedIntegerValue] == CDVCommandStatus_OK)) {
        return [self.commandDelegate sendPluginResult:resultForRegisterPlist callbackId:callbackId];
    }
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

@end
