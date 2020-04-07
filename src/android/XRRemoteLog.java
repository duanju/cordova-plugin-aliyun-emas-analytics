package org.apache.cordova.xrpreference;

import com.alibaba.ha.adapter.service.tlog.TLogLevel;
import com.alibaba.ha.adapter.service.tlog.TLogService;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;

public class XRRemoteLog extends CordovaPlugin {

    /** LOG TAG */
    private static final String LOG_TAG = "AliyunEMAS XRRemoteLog";
    private static String TAG = "AliyunTLog";
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        LOG.d(LOG_TAG, "execute");
        boolean ret = false;
        // 配置model
        String model = args.getString(0);
        // 配置message
        String message = args.getString(1);
        //设置可上传日志级别，默认 e 级别
        TLogService.updateLogLevel(TLogLevel.VERBOSE);
        if (action.equals("info")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    TLogService.logi(model,TAG,message);
                }
            });
            ret = true;
        } else if(action.equals("error")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    TLogService.loge(model,TAG,message);
                }
            });
            ret = true;
        } else if(action.equals("warn")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    TLogService.logw(model,TAG,message);
                }
            });
            ret = true;
        } else if(action.equals("debug")){
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    TLogService.logd(model,TAG,message);
                }
            });
            ret = true;
        }
        return ret;
    }
}
