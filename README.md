# cordova-plugin-aliyun-emas-analytics
> The `XRPreference` object provides some functions to help the iOS and Android integrate AliCloud EMAS SDK.

## Installation

This installation method requires cordova 5.0+
```
cordova plugin add cordova-plugin-statusbar
```

It is also possible to install via repo url directly ( unstable )

    cordova plugin add https://github.com/pi2star/cordova-plugin-aliyun-emas-analytics.git


Preferences
-----------

#### config.xml

-  __EmasAppKey__ (String, not null). 

        <preference name="EmasAppKey" value="your emas.appKey" />


- __EmasAppSecret__ (String, not null). 

        <preference name="EmasAppSecret" value="your emas.appSecret" />

- __EmasBundleId__ (String, not null). 

        <preference name="EmasBundleId" value="your emas.bundleId" />

Methods
-------
This plugin defines global `XRPreference` object.

Although in the global scope, it is not available until after the `deviceready` event.

    document.addEventListener("deviceready", onDeviceReady, false);
    function onDeviceReady() {
        console.log(XRPreference);
    }

- XRPreference.prepareData
- XRPreference.autoInitWithArgs
- XRPreference.start



Supported Platforms
-------------------

- iOS 8+
- Android 5+

Quick Example
-------------

    XRPreference.prepareData('param',(value)=>{
                console.log(value);
            },(e)=>{
                console.log(e);
            });
    
    XRPreference.autoInitWithArgs(['appVersion', 'channel', 'nick'], (value) => {
            alert(value)
        }, (e) => {
            alert(e)
        });
    XRPreference.start('',()=>{},()=>{});

XRPreference.prepareData
=================

desc

XRPreference.autoInitWithArgs
=================

desc

XRPreference.start
=================

desc

