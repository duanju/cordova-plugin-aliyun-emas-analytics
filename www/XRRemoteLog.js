var exec = require('cordova/exec');

var XRLog = {

    error: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title,msg];
        exec(null, null, 'XRRemoteLog', 'error', arr);
    },

    warn: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title,msg];
        exec(null, null, 'XRRemoteLog', 'warn', arr);
    },
    debug: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title,msg];
        exec(null, null, 'XRRemoteLog', 'debug', arr);
    },
    info: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title,msg];
        exec(null, null, 'XRRemoteLog', 'info', arr);
    }
};

module.exports = XRLog;
