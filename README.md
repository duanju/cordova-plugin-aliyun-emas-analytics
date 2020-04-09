# 导航
- 简介
- 安装
- 项目集成
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
## 项目集成
在安装插件成功之后需要对Cordova项目进行一定配置才能进行正常使用
### 文件配置
在`Cordova`项目进行以下配置：的`config.xml`下需进行以下配置：
#### ios
1、将`AliyunEmasServices-Info.plist`放入项目根目录（与`config.xml`同目录）
2、`config.xml`添加如下配置：
```xml
<platform name="ios">
    <preference name="AliyunXNServe" value="true"/>
    <preference name="AliyunCrashServe" value="true"/>
    <preference name="AliyunTlogServe" value="true"/>
    <preference name="AliyunOpenDebug" value="true"/>
    <preference name="AliyunMobileAnalyticsServe" value="true"/>
</platform>
```
#### android
1、将`aliyun-emas-services.json`放入项目根目录（与`config.xml`同目录）
2、`config.xml`添加如下配置：
```xml
<platform name="android">
    <preference name="AliyunXNServe" value="true"/>
    <preference name="AliyunCrashServe" value="true"/>
    <preference name="AliyunTlogServe" value="true"/>
    <preference name="AliyunOpenDebug" value="true"/>
    <preference name="AliyunMobileAnalyticsServe" value="true"/>
</platform>
```
这几个配置皆与自启动服务相关，如果开发者需要自动启动服务api的话，则这几项必须被设置，后续在API说明中会有详细说明，其中：
- `AliyunXNServe`：是否开启性能分析服务
- `AliyunCrashServe`：是否开启崩溃分析服务
- `AliyunTlogServe`：是否开启远程日志服务
- `AliyunOpenDebug`：是否开启debug模式
- `AliyunMobileAnalyticsServe`：是否开启移动数据分析服务

### 具体用法
> 使用前提：已在`config.xml`中对相关服务进行配置

**1、启动服务**
```
// 在项目`deviceReady`中调用
AliyunEMAS.autoStartAliyunAnalyticsWithArgs('new_appVersion', 'new_channel', 'new_nick', (value) => {
    console.log(value);
}, (e) => {
    console.error(e)
})
```
**2、远程日志**
> 在任意需要被调用的地方直接执行
```
// 打印一条警告信息
AliyunEMAS.warn('警告', '这是一条warn信息');

// 打印一条错误信息
AliyunEMAS.error('错误', '这是一条error信息');

// 打印一条debug信息
AliyunEMAS.debug('Debug', '这是一条debug信息');

// 默认打印
AliyunEMAS.info('默认', '这是一条info信息');
```
**3、自定义事件**
```
// 自定义扩展参数，格式{key-value,...}
var params = {key4: 'value4', key5: 'value5'}
AliyunEMAS.customEventBuilder('事件名称', '页面名称', 12, params)
```
### 支持平台

- ios 8+
- android 5+


## API说明
```
//////////////// 初始化EMAS ////////////////////
// --------------------------------------------
/**
 * @brief 初始化准备数据
 * @details 优先调用，否则可能会出现意想不到的bug
 */
registerData: function (appVersion, channel, nick, success, error) {
    if (!appVersion || !channel || !nick) {
        console.error('参数不能为空');
        return error('appVersion, channel, nick 不能为空');
    }
    exec(success, error, 'AliyunEMAS', 'registerData', [appVersion, channel, nick]);
},

/**
 * @brief 性能监控初始化接口（自动读取appKey、appSecret）
 * @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
 */
initAlicloudAPM: function () {
    exec(null, null, 'AliyunEMAS', 'initAlicloudAPM', null);
},

/**
 * @brief 远程日志初始化接口（自动读取appKey、appSecret）
 * @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
 */
initAlicloudTlog: function () {
    exec(null, null, 'AliyunEMAS', 'initAlicloudTlog', null);
},

/**
 * @brief 崩溃分析始化接口（自动读取appKey、appSecret）
 * @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
 */
initAlicloudCrash: function () {
    exec(null, null, 'AliyunEMAS', 'initAlicloudCrash', null);
},

/**
 * @brief 启动AppMonitor服务
 * @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
 */
start: function () {
    exec(null, null, 'AliyunEMAS', 'start', null);
},

/**
 @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
 自动读取appKey、appSecret
 只需单独集成此api即可
 启动服务需在config.xml中配置，具体参照文档说明
 函数会返回失败信息，成功无返回
 */
autoStartAliyunAnalyticsWithArgs: function (appVersion, channel, nick, success, error) {
    if (!appVersion || !channel || !nick) {
        console.error('参数不能为空');
        return error('appVersion, channel, nick 不能为空');
    }
    exec(success, error, 'AliyunEMAS', 'autoStartAliyunAnalyticsWithArgs', [appVersion, channel, nick]);
},

//////////////// 远程日志 log //////////////////
// --------------------------------------------

error: function (title, msg) {
    if (!title || !msg || title.length === 0 || msg.length === 0) {
        console.log('参数错误');
        return;
    }
    const arr = [title, msg];
    exec(null, null, 'AliyunEMAS', 'error', arr);
},

warn: function (title, msg) {
    if (!title || !msg || title.length === 0 || msg.length === 0) {
        console.log('参数错误');
        return;
    }
    const arr = [title, msg];
    exec(null, null, 'AliyunEMAS', 'warn', arr);
},
debug: function (title, msg) {
    if (!title || !msg || title.length === 0 || msg.length === 0) {
        console.log('参数错误');
        return;
    }
    const arr = [title, msg];
    exec(null, null, 'AliyunEMAS', 'debug', arr);
},
info: function (title, msg) {
    if (!title || !msg || title.length === 0 || msg.length === 0) {
        console.log('参数错误');
        return;
    }
    const arr = [title, msg];
    exec(null, null, 'AliyunEMAS', 'info', arr);
},

//////////////// 移动数据分析 ////////////////////
// --------------------------------------------

/**
 @brief 初始化移动数据分析（自动）
 如果在config.xml中配置了`AliyunMobileAnalyticsServe = true`,则无需调用该api
 */
autoInitManSdk: function () {
    exec(null, null, 'AliyunEMAS', 'autoInitManSdk', null);
},

/**
 @brief 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 备注: 阿里云 平台上的登录会员 UV 指标依赖该接口
 @param userAccount 用户昵称
 @param userId 用户id
 */
userLogin: function (userAccount, userId) {
    if (!userAccount || !userId || userAccount.length === 0 || userId.length === 0) {
        console.error('参数不能为空');
        return;
    }
    exec(null, null, 'AliyunEMAS', 'userLogin', [userAccount, userId]);
},

/**
 @brief 注册会员
 功能: 产生一条注册会员事件日志
 调用时机: 注册时调用
 备注: 阿里云 平台上注册会员指标依赖该接口
 @param userId 用户id
 */
userRegister: function (userId) {
    if (!userId || userId.length === 0) {
        console.error('参数不能为空');
        return;
    }
    exec(null, null, 'AliyunEMAS', 'userRegister', [userId]);
},

/**
 @brief 自定义事件
 @param eventLabel 设置自定义事件标签
 @param pageName 设置自定义事件页面名称
 @param duration 设置自定义事件持续时间 单位（ms）
 @param args 设置自定义事件扩展参数 格式：{key-value,...} 可为空
 */
customEventBuilder: function (eventLabel,pageName,duration,args={}) {
    if (!eventLabel || !pageName) {
        console.error('参数不能为空');
        return;
    }
    exec(null, null, 'AliyunEMAS', 'customEventBuilder', [eventLabel,pageName,duration,args]);
}, 
```


