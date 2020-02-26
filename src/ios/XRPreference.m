//
//  XRPreference.m
//  cordova-demo
//
//  Created by 袁训锐 on 2020/2/20.
//

#import "XRPreference.h"
#import <AlicloudAPM/AlicloudAPMProvider.h>
#import <AlicloudHAUtil/AlicloudHAProvider.h>

NSString *const ROOTCONFIGKEY = @"config";

#define XRLog(s, ...) NSLog(@"<%s>%@", __FUNCTION__, [NSString stringWithFormat:(s), ## __VA_ARGS__]);

@implementation XRPreference

- (void)initData:(CDVInvokedUrlCommand *)command {
    NSArray *deploymentConfigKeys = @[@"emas.appKey", @"emas.appSecret", @"emas.bundleId"];
    NSString *callbackId = command.callbackId;
    CDVPluginResult *result = nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"AliyunEmasServices-Info" ofType:@"plist"];
    NSMutableDictionary *rootDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *dictPreference = ((CDVViewController *)self.viewController).settings;
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:deploymentConfigKeys.count];
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
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"config.xml中未配置:%@", key]];
                [self.commandDelegate sendPluginResult:result callbackId:callbackId];
                return;
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
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", @"未找到AliyunEmasServices-Info.plist文件，可直接从阿里平台下载并导入到工程根目录，届时无需调用该API"]];
    }
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)autoInitWithArgs:(CDVInvokedUrlCommand *)command{
    //1、获取调用命令的唯一ID
    NSString *callbackId = command.callbackId;
    
    NSString *appVersion = nil;
    NSString *channel = nil;
    NSString *nick = nil;
    
    CDVPluginResult *result = nil;
    if(command.arguments.count&&command.arguments.count>=3){
        appVersion = [command.arguments objectAtIndex:0];
        channel = [command.arguments objectAtIndex:1];
        nick = [command.arguments objectAtIndex:2];

        [[AlicloudAPMProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:@[appVersion,channel,nick]];
    } else{
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%s %@",__FUNCTION__,@"传入的参数不合规"]];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (void)start:(CDVInvokedUrlCommand *)command{
    NSLog(@"私人定制  %s",__FUNCTION__);
    //[AlicloudHAProvider start];
}
@end
