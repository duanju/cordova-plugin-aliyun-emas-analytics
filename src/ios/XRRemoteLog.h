//
//  XRRemoteLog.h
//  cordova_demo
//
//  Created by 袁训锐 on 2020/2/28.
//

#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface XRRemoteLog : CDVPlugin

- (void)error:(CDVInvokedUrlCommand *)command;
- (void)warn:(CDVInvokedUrlCommand *)command;
- (void)info:(CDVInvokedUrlCommand *)command;
- (void)debug:(CDVInvokedUrlCommand *)command;
@end

NS_ASSUME_NONNULL_END
