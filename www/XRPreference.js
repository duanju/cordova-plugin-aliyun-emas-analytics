var exec = require('cordova/exec');

var XRPreference = {

    prepareData:function(arg0, success, error) {
        exec(success, error, 'XRPreference', 'initData', [arg0]);
    },
    start: function (arg0, success, error) {
        exec(success, error, 'XRPreference', 'start', [arg0]);
    },

    autoInitWithArgs: function (args, success, error) {
        exec(success, error, 'XRPreference', 'autoInitWithArgs', args);
    }
};

module.exports = XRPreference;
