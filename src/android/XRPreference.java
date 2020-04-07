package org.apache.cordova.xrpreference;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import com.alibaba.ha.adapter.AliHaAdapter;
import com.alibaba.ha.adapter.AliHaConfig;
import com.alibaba.ha.adapter.Plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * This class echoes a string called from JavaScript.
 */
public class XRPreference extends CordovaPlugin {

    /** LOG TAG */
    private static final String LOG_TAG = "AliyunEMAS";
    // 配置文件读取
    private static String AliyunConfigFileName = "aliyun-emas-services.json";
    private static String AliyunAppKey;
    private static String AliyunAppSecret;
    private static String AliyunTLogRsaPublicKey; // 远程日志&性能分析
    // API基本入参信息
    private static String AppVersion;
    private static String Channel;
    private static String UserNick;
    // 服务
    private static Boolean AliyunXNServe = false;
    private static Boolean AliyunCrashServe = false;
    private static Boolean AliyunTlogServe = false;
    // 工具
    private static Boolean AliyunOpenDebug = false;


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        LOG.d(LOG_TAG, "execute");
        boolean ret = false;
        if (action.equals("registerData")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    registerData(args, callbackContext);
                }
            });
            ret = true;
        } else if (action.equals("initAlicloudAPM")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    initAlicloudAPM();
                }
            });
            ret = true;
        } else if (action.equals("initAlicloudCrash")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    initAlicloudCrash();
                }
            });
            ret = true;
        } else if (action.equals("initAlicloudTlog")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    initAlicloudTlog();
                }
            });
            ret = true;
        } else if (action.equals("autoStartAliyunAnalyticsWithArgs")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    autoStartAliyunAnalyticsWithArgs(args, callbackContext);
                }
            });
            ret = true;
        }
        return ret;
    }

    /**
     * 初始化参数
     * 方法传入+JSON配置文件读取
     */
    private void registerData(JSONArray args, CallbackContext callbackContext) {
        LOG.d(LOG_TAG, "registerData");
        try {
            if (args == null || args.length() < 3) {
                callbackContext.error("传入参数错误");
                return;
            }
            // 入参配置
            AppVersion = args.getString(0);
            Channel = args.getString(0);
            UserNick = args.getString(0);
            // json文件读取
            String jsonStr = getJson(AliyunConfigFileName, cordova.getContext());
            JSONObject jsonObj = new JSONObject(jsonStr);
            JSONObject configObj = jsonObj.getJSONObject("config");
            AliyunAppKey = configObj.getString("emas.appKey");
            AliyunAppSecret = configObj.getString("emas.appSecret");
            AliyunTLogRsaPublicKey = configObj.getString("appmonitor.tlog.rsaSecret");
            // 读取注册服务信息
            AliyunXNServe = jsonObj.getBoolean("AliyunXNServe");
            AliyunCrashServe = jsonObj.getBoolean("AliyunCrashServe");
            AliyunTlogServe = jsonObj.getBoolean("AliyunTlogServe");
            // tool
            AliyunOpenDebug = jsonObj.getBoolean("AliyunOpenDebug");

            if (callbackContext != null) {
                callbackContext.success("success");
            }
        } catch (JSONException e) {
            Log.e("registerData:",e.getMessage());
            if (callbackContext != null) {
                callbackContext.error(e.getMessage());
            }
        }
    }

    /**
     * 阿里云EMAS 性能测试
     */
    private void initAlicloudAPM() {
        LOG.d(LOG_TAG, "initAlicloudAPM");
        AliHaConfig config = new AliHaConfig();
        config.appKey = AliyunAppKey;         //appkey
        config.appSecret = AliyunAppSecret;  //appsecret
        config.appVersion = AppVersion;           //应用的版本号信息

        config.channel = Channel;        //应用的渠道号标记，自定义
        config.userNick = UserNick;
        config.application = cordova.getActivity().getApplication();
        config.context = cordova.getContext();
        config.isAliyunos = false;             //是否为yunos
        config.rsaPublicKey = AliyunTLogRsaPublicKey;
        AliHaAdapter.getInstance().addPlugin(Plugin.apm);
        AliHaAdapter.getInstance().start(config);
    }

    /**
     * 阿里云EMAS 远程日志
     */
    private void initAlicloudTlog() {
        LOG.d(LOG_TAG, "initAlicloudTlog");
        AliHaConfig config = new AliHaConfig();
        config.appKey = AliyunAppKey;         //appkey
        config.appSecret = AliyunAppSecret;  //appsecret
        config.appVersion = AppVersion;           //应用的版本号信息

        config.channel = Channel;        //应用的渠道号标记，自定义
        config.userNick = UserNick;
        config.application = cordova.getActivity().getApplication();
        config.context = cordova.getContext();
        config.isAliyunos = false;             //是否为yunos
        config.rsaPublicKey = AliyunTLogRsaPublicKey;

        AliHaAdapter.getInstance().addPlugin(Plugin.tlog);
        AliHaAdapter.getInstance().openDebug(AliyunOpenDebug);
        AliHaAdapter.getInstance().start(config);
    }

    /**
     * 阿里云EMAS 崩溃分析
     */
    private void initAlicloudCrash() {
        LOG.d(LOG_TAG, "initAlicloudCrash");
        AliHaConfig config = new AliHaConfig();
        config.appKey = AliyunAppKey;         //appkey
        config.appSecret = AliyunAppSecret;  //appsecret
        config.appVersion = AppVersion;           //应用的版本号信息

        config.channel = Channel;        //应用的渠道号标记，自定义
        config.userNick = UserNick;
        config.application = cordova.getActivity().getApplication();
        config.context = cordova.getContext();
        config.isAliyunos = false;             //是否为yunos
        config.rsaPublicKey = AliyunTLogRsaPublicKey;

        //启动CrashReporter
        AliHaAdapter.getInstance().addPlugin(Plugin.crashreporter);
        AliHaAdapter.getInstance().start(config);
    }

    /***
     * 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
     */
    private void autoStartAliyunAnalyticsWithArgs(JSONArray args, CallbackContext callbackContext) {
        LOG.d(LOG_TAG, "autoStartAliyunAnalyticsWithArgs");
        // 参数配置
        registerData(args, null);
        // 服务注册
        AliHaConfig config = new AliHaConfig();
        config.appKey = AliyunAppKey;         //appkey
        config.appSecret = AliyunAppSecret;  //appsecret
        config.appVersion = AppVersion;           //应用的版本号信息

        config.channel = Channel;        //应用的渠道号标记，自定义
        config.userNick = UserNick;
        config.application = cordova.getActivity().getApplication();
        config.context = cordova.getContext();
        config.isAliyunos = false;             //是否为yunos
        config.rsaPublicKey = AliyunTLogRsaPublicKey;

        if(AliyunXNServe){
            // 注册性能分析服务
            AliHaAdapter.getInstance().addPlugin(Plugin.apm);
        }
        if(AliyunCrashServe){
            // 注册CrashReporter
            AliHaAdapter.getInstance().addPlugin(Plugin.crashreporter);
        }
        if(AliyunTlogServe){
            // 注册远程日志
            AliHaAdapter.getInstance().addPlugin(Plugin.tlog);
        }
        // 开启debug模式
        AliHaAdapter.getInstance().openDebug(AliyunOpenDebug);
        // 启动服务
        AliHaAdapter.getInstance().start(config);
        callbackContext.success("");
    }

    /**
     * 读取assets本地json
     *
     * @param fileName
     * @param context
     * @return
     */
    public static String getJson(String fileName, Context context) {
        //将json数据变成字符串
        StringBuilder stringBuilder = new StringBuilder();
        try {
            //获取assets资源管理器
            AssetManager assetManager = context.getAssets();
            //使用IO流读取json文件内容
            //通过管理器打开文件并读取
            InputStreamReader inputStreamReader = new InputStreamReader(assetManager.open(fileName), "UTF-8");
            //使用字符高效流
            BufferedReader bf = new BufferedReader(inputStreamReader);

            String line;
            while ((line = bf.readLine()) != null) {
                stringBuilder.append(line);
            }
            bf.close();
            inputStreamReader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }
}
