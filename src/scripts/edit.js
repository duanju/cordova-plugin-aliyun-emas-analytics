var fs = require('fs');
var plist = require('plist');
var xml2js = require('xml2js');

module.exports = function (ctx) {

    var filePath = ctx.opts.projectRoot + '/plugins/' + ctx.opts.plugin.id + '/src/AliyunEmasServices-Info.plist';
    var configPath = ctx.opts.projectRoot + '/config.xml';
    // console.log('-------->',ctx.opts.platforms.includes('android'))
    var xml = fs.readFileSync(filePath, 'utf8');
    var obj = plist.parse(xml);
    var configXML = fs.readFileSync(configPath, 'utf8');
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

    obj.config['emas.appKey'] = preferences['EmasAppKey'] || ''
    obj.config['emas.appSecret'] = preferences['EmasAppSecret'] || ''
    obj.config['emas.bundleId'] = preferences['EmasBundleId'] || ''
    console.log(obj);

    xml = plist.build(obj);
    fs.writeFileSync(filePath, xml, {encoding: 'utf8'});
};
