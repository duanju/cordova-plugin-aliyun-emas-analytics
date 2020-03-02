var fs = require('fs');
var plist = require('plist');
var xml2js = require('xml2js');
var FILEPATH = './plugins/cordova-plugin-aliyun-emas-analytics/src/AliyunEmasServices-Info.plist';
var CONFIGPATH = './config.xml';

module.exports = function (ctx) {

    var xml = fs.readFileSync(FILEPATH, 'utf8');
    var obj = plist.parse(xml);
    var configXML = fs.readFileSync(CONFIGPATH, 'utf8');
    var xmlParser = new xml2js.Parser({explicitArray: false, ignoreAttrs: false})
    var preferences = {}
    xmlParser.parseString(configXML, function (err, result) {
        var json = result.widget.platform[1].preference;
        for (var i = 0; i < json.length; i++) {
            var key = json[i].$.name
            var value = json[i].$.value
            preferences[key] = value;
        }
    })

    obj.test = 'nihao'
    obj.config['emas.appKey'] = preferences['EmasAppKey'] || ''
    obj.config['emas.appSecret'] = preferences['EmasAppSecret'] || ''
    obj.config['emas.bundleId'] = preferences['EmasBundleId'] || ''
    // console.log(obj);

    xml = plist.build(obj);
    fs.writeFileSync(FILEPATH, xml, {encoding: 'utf8'});

};
