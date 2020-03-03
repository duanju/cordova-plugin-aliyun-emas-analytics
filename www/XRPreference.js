var exec = require('cordova/exec');

var XRPreference = {

    /**
     * @brief 初始化准备数据
     * @details 优先调用，否则可能会出现意想不到的bug
     */
    registerData: function (args, success, error) {
        exec(success, error, 'XRPreference', 'registerData', args);
    },

    /**
     * @brief 性能监控初始化接口（自动读取appKey、appSecret）
     * @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudAPM: function () {
        exec(null, null, 'XRPreference', 'initAlicloudAPM', null);
    },

    /**
     * @brief 远程日志初始化接口（自动读取appKey、appSecret）
     * @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudTlog: function () {
        exec(null, null, 'XRPreference', 'initAlicloudTlog', null);
    },

    /**
     * @brief 崩溃分析始化接口（自动读取appKey、appSecret）
     * @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudCrash: function () {
        exec(null, null, 'XRPreference', 'initAlicloudCrash', null);
    },

    /**
     * @brief 启动AppMonitor服务
     * @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
     */
    start: function () {
        exec(null, null, 'XRPreference', 'start', null);
    },

    /**
     @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
     自动读取appKey、appSecret
     只需单独集成此api即可
     启动服务需在config.xml中配置，具体参照文档说明
     函数会返回失败信息，成功无返回
     */
    autoStartAliyunAnalyticsWithArgs: function (args, success, error) {
        exec(success, error, 'XRPreference', 'autoStartAliyunAnalyticsWithArgs', args);
    }
};

module.exports = XRPreference;
