# 导航
- 简介
- 安装
- 使用
- API说明
## 简介
`cordova-plugin-aliyun-emas-analytics`是针对阿里云EMAS中`性能分析`、`远程日志`、`崩溃分析`三模块而开发的`Cordova`插件，用于解决上述三种阿里云服务只能在原生平台使用的弊端，开发者可以通过集成此插件来实现在任意Cordova框架上使用阿里云EMAS服务

## 安装
安装方式分两种：
```shell
# 通过git安装
cordova plugin add https://github.com/pi2star/cordova-plugin-aliyun-emas-analytics.git
```
```shell
# 通过npm安装
cordova plugin add cordova-plugin-aliyun-emas-analytics
```
> 注：
- 开发者在使用该插件前需要在阿里云平台注册相关服务
- 插件安装好后请执行以下命令以让插件生效：

```shell
# 不存在platforms
cordova platform add <ios/android>
# 已存在platforms
cordova prepare <ios/android>
```
## 使用
在安装插件成功之后需要对Cordova项目进行一定配置才能进行正常使用
### 配置
在`Cordova`项目进行以下配置：的`config.xml`下需进行以下配置：
#### ios
1、将`AliyunEmasServices-Info.plist`放入项目根目录（与`config.xml`同目录）
2、`config.xml`添加如下配置：
```xml
<platform name="ios">
    <preference name="EmasAppKey" value="your-aliyun-appkey"/>
    <preference name="EmasAppSecret" value="your-aliyun-appsecret"/>
    <preference name="EmasBundleId" value="your-aliyun-bundleid"/>
    <preference name="AliyunXNServe" value="true"/>
    <preference name="AliyunCrashServe" value="true"/>
    <preference name="AliyunTlogServe" value="true"/>
</platform>
```
#### android
1、将`aliyun-emas-services.json`放入项目根目录（与`config.xml`同目录）
2、`config.xml`添加如下配置：
```xml
<platform name="android">
    <preference name="EmasAppKey" value="28434716"/>
    <preference name="EmasAppSecret" value="5a6b612fc1df072244715c27f2cabd92"/>
    <preference name="EmasPackageName" value="com.cordova.xry"/>
    <preference name="AliyunXNServe" value="true"/>
    <preference name="AliyunCrashServe" value="true"/>
    <preference name="AliyunTlogServe" value="true"/>
    <preference name="AliyunOpenDebug" value="true"/>
</platform>
```
前三个变量均与开发者从官方下载的ios平台为`AliyunEmasServices-Info.plist`，android平台为`aliyun-emas-services.json`有关，其中：
- EmasAppKey：必须与`emas.appKey`所对应的值保持一致
- EmasAppSecret：必须与`emas.appSecret`所对应的值保持一致
- EmasBundleId：必须与`emas.bundleId`所对应的值保持一致
后三个变量与自启动服务相关，如果开发者需要自动启动服务api的话，则这三个变量必须被设置，后续在API说明中会有详细说明，其中：
- AliyunXNServe：是否开启性能分析服务
- AliyunCrashServe：是否开启崩溃分析服务
- AliyunTlogServe：是否开启远程日志服务
- AliyunOpenDebug：是否开启debug模式

### 支持平台

- ios 8+
- android 5+

### 项目集成

## API说明
```
/**
     * @brief 初始化准备数据
     * @details 优先调用，否则可能会出现意想不到的bug
     */
    registerData: function (args, success, error) ；

    /**
     * @brief 性能监控初始化接口（自动读取appKey、appSecret）
     * @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudAPM: function () ；

    /**
     * @brief 远程日志初始化接口（自动读取appKey、appSecret）
     * @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudTlog: function () ；

    /**
     * @brief 崩溃分析始化接口（自动读取appKey、appSecret）
     * @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudCrash: function () ；

    /**
     * @brief 启动AppMonitor服务
     * @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
     */
    start: function ()；

    /**
     @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
     自动读取appKey、appSecret
     只需单独集成此api即可
     启动服务需在config.xml中配置，具体参照文档说明
     函数会返回失败信息，成功无返回
     */
    autoStartAliyunAnalyticsWithArgs: function (args, success, error)；
    
    // 远程日志打印相关
    error: function (title, msg) ；
    warn: function (title, msg) ；
    debug: function (title, msg)；
    info: function (title, msg) ； 
```


