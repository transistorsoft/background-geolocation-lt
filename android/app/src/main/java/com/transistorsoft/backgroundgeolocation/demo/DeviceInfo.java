package com.transistorsoft.backgroundgeolocation.demo;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.provider.Settings;

public class DeviceInfo {
    private static DeviceInfo mInstance = null;

    public static DeviceInfo getInstance(Context context) {
        if (mInstance == null) {
            mInstance = getInstanceSynchronized(context.getApplicationContext());
        }
        return mInstance;
    }

    private static synchronized DeviceInfo getInstanceSynchronized(Context context) {
        if (mInstance == null) mInstance = new DeviceInfo(context.getApplicationContext());
        return mInstance;
    }

    private String mUniqueId;
    private String mModel;
    private String mPlatform = "Android";
    private String mManufacturer;
    private String mVersion;

    @SuppressLint("HardwareIds")
    public DeviceInfo(Context context) {
        mUniqueId       = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        mModel          = Build.MODEL;
        mManufacturer   = Build.MANUFACTURER;
        mVersion        = Build.VERSION.RELEASE;
    }

    public String getUniqueId() { return mUniqueId; }
    public String getModel() { return mModel; }
    public String getPlatform() { return mPlatform; }
    public String getManufacturer() { return mManufacturer; }
    public String getVersion() { return mVersion; }
}
