var fs = require('fs');
var plist = require('plist');
var xml2js = require('xml2js');

const appKey = 'EmasAppKey';
const appSecret = 'EmasAppSecret';
const bundleId = 'EmasBundleId';

// 服务
const AliyunXNServe = 'AliyunXNServe';
const AliyunCrashServe = 'AliyunCrashServe';
const AliyunTlogServe = 'AliyunTlogServe';
const AliyunOpenDebug = 'AliyunOpenDebug';
const AliyunMobileAnalyticsServe = 'AliyunMobileAnalyticsServe';

module.exports = function (ctx) {

    if (!ctx.opts.platforms.includes('ios')) {
        return;
    }
    var configPath = ctx.opts.projectRoot + '/config.xml';
    var configXML = fs.readFileSync(configPath, 'utf8');
    var xmlParser = new xml2js.Parser({explicitArray: false, ignoreAttrs: false})
    var preferences = {}
    var projectName = '';
    xmlParser.parseString(configXML, function (err, result) {
        projectName = result.widget.name;
        // console.log('--------> ', projectName);
        var json = result.widget.platform[1].preference;
        for (var i = 0; i < json.length; i++) {
            var key = `${json[i].$.name}`
            var value = json[i].$.value
            preferences[key] = value;
        }
    })
    var iosFilePath = ctx.opts.projectRoot + '/platforms/ios/' + projectName + '/Resources/AliyunEmasServices-Info.plist';
    var filePath = ctx.opts.projectRoot + '/AliyunEmasServices-Info.plist';
    var xml;
    try {
        xml = fs.readFileSync(filePath, 'utf8');
    }catch (e) {
        console.error(e)
        return;
    }

    var obj = plist.parse(xml);
    obj.config['emas.appKey'] = preferences['emas_appKey'] || ''
    obj.config['emas.appSecret'] = preferences['emas_appSecret'] || ''
    obj.config['emas.bundleId'] = preferences['emas_bundleId'] || ''
    obj.config['hotfix.idSecret'] = preferences['hotfix_idSecret'] || ''
    obj.config['hotfix.rsaSecret'] = preferences['hotfix_rsaSecret'] || ''
    obj.config['httpdns.accountId'] = preferences['httpdns_accountId'] || ''
    obj.config['httpdns.secretKey'] = preferences['httpdns_secretKey'] || ''
    obj.config['appmonitor.tlog.rsaSecret'] = preferences['appmonitor_tlog_rsaSecret'] || ''
    obj.config['appmonitor.rsaSecret'] = preferences['appmonitor_rsaSecret'] || ''

    // 注册服务
    obj.AliyunXNServe = preferences[AliyunXNServe] || 'false'
    obj.AliyunCrashServe = preferences[AliyunCrashServe] || 'false'
    obj.AliyunTlogServe = preferences[AliyunTlogServe] || 'false'
    obj.AliyunOpenDebug = preferences[AliyunOpenDebug] || 'false'
    obj.AliyunMobileAnalyticsServe = preferences[AliyunMobileAnalyticsServe] || 'false'
    if(preferences[AliyunOpenDebug]==='true'){
        console.log(obj);
    }

    xml = plist.build(obj);
    fs.writeFileSync(iosFilePath, xml, {encoding: 'utf8'});
};
