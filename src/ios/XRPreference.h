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
- (void)initData:(CDVInvokedUrlCommand *)command;

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
* @param appVersion app版本，会上报
* @param channel 渠道标记，自定义，会上报
* @param nick 昵称，自定义，会上报
*/
- (void)autoInitWithArgs:(CDVInvokedUrlCommand *)command;

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start:(CDVInvokedUrlCommand *)command;

@end

NS_ASSUME_NONNULL_END
