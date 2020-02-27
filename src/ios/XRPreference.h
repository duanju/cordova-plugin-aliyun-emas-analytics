//
//  XRPreference.h
//  cordova-demo
//
//  Created by 袁训锐 on 2020/2/20.
//

#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRPreference : CDVPlugin

/*!
* @brief 初始化准备数据
* @details 优先调用，否则可能会出现意想不到的bug
*/
- (void)registerData:(CDVInvokedUrlCommand *)command;

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudAPM:(CDVInvokedUrlCommand *)command;

/*!
* @brief 远程日志初始化接口（自动读取appKey、appSecret）
* @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudTlog:(CDVInvokedUrlCommand *)command;

/*!
* @brief 崩溃分析始化接口（自动读取appKey、appSecret）
* @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudCrash:(CDVInvokedUrlCommand *)command;

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
