var exec = require('cordova/exec');

var XRPreference = {

    registerData:function(args, success, error) {
        exec(success, error, 'XRPreference', 'registerData', args);
    },

    initAlicloudAPM:function () {
        exec(null, null, 'XRPreference', 'initAlicloudAPM', null);
    },
    initAlicloudTlog:function () {
        exec(null, null, 'XRPreference', 'initAlicloudTlog', null);
    },
    initAlicloudCrash:function () {
        exec(null, null, 'XRPreference', 'initAlicloudCrash', null);
    },
    start: function () {
        exec(null, null, 'XRPreference', 'start', null);
    },
    autoStartAliyunAnalyticsWithArgs:function (args, success, error) {
        exec(success, error, 'XRPreference', 'autoStartAliyunAnalyticsWithArgs', args);
    }
};

module.exports = XRPreference;
