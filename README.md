
Background Geolocation Module for iOS &amp; Android
==============================================================================

[![](https://dl.dropboxusercontent.com/s/nm4s5ltlug63vv8/logo-150-print.png?dl=1)](https://www.transistorsoft.com)

-------------------------------------------------------------------------------

The *most* sophisticated background **location-tracking & geofencing** module with battery-conscious motion-detection intelligence for **iOS** and **Android**.

The plugin's [Philosophy of Operation](../../wiki/Philosophy-of-Operation) is to use **motion-detection** APIs (using accelerometer, gyroscope and magnetometer) to detect when the device is *moving* and *stationary*.  

- When the device is detected to be **moving**, the plugin will *automatically* start recording a location according to the configured `distanceFilter` (meters).  

- When the device is detected be **stationary**, the plugin will automatically turn off location-services to conserve energy.

Also available for [React Native](https://github.com/transistorsoft/react-native-background-geolocation) [Cordova](https://github.com/transistorsoft/cordova-background-geolocation-lt) and [NativeScript](https://github.com/transistorsoft/nativescript-background-geolocation-lt)

----------------------------------------------------------------------------

[![Google Play](https://dl.dropboxusercontent.com/s/80rf906x0fheb26/google-play-icon.png?dl=1)](https://play.google.com/store/apps/details?id=com.transistorsoft.backgroundgeolocation.react)

![Home](https://dl.dropboxusercontent.com/s/wa43w1n3xhkjn0i/home-framed-350.png?dl=1)
![Settings](https://dl.dropboxusercontent.com/s/8oad228siog49kt/settings-framed-350.png?dl=1)


# Contents
- ### :books: [API Documentation](./docs/README.md)
  - :wrench: [Configuration Options](./docs/README.md#wrench-configuration-options)
  - :zap: [Events](./docs/README.md#zap-events)
  - :small_blue_diamond: [Methods](./docs/README.md#large_blue_diamond-methods)        
- ### [Installing the Plugin](#large_blue_diamond-installing-the-plugin)
- ### [Setup Guides](#large_blue_diamond-setup-guides)
- ### [Configure your License](#large_blue_diamond-configure-your-license)
- ### [Android SDK Setup](#large_blue_diamond-android-sdk)
- ### [Using the plugin](#large_blue_diamond-using-the-plugin)
- ### [Example](#large_blue_diamond-example)
- ### [Debugging](../../wiki/Debugging)
- ### [Demo Application](#large_blue_diamond-demo-application)
- ### [Testing Server](#large_blue_diamond-simple-testing-server)


## :large_blue_diamond: Installing the Plugin

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

Create a folder in the root of your application project, eg: `/Libraries` and place the extracted **`background-geolocation`** folder into it:

eg: :open_file_folder: **`Libraries/background-geolocation-lt`**

## :large_blue_diamond: Setup Guides

### [iOS Setup Guide](docs/INSTALL-IOS.md)

### [Android Setup Guide](docs/INSTALL-ANDROID.md)

## :large_blue_diamond: Using the plugin ##

```java
package com.your.app;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;

public class MainActivity extends AppCompatActivity {
    private static String TAG = "MyApp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Get a reference to the API by providing it a Context & Intent
        BackgroundGeolocation adapter = BackgroundGeolocation.getInstance(this, getIntent());
    }

}
```


## :large_blue_diamond: Example

```java

```java
package com.your.app;

import com.transistorsoft.locationmanager.adapter.BackgroundGeolocation;

public class MainActivity extends AppCompatActivity {
    private static String TAG = "MyApp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Get a reference to the plugin
        BackgroundGeolocation adapter = BackgroundGeolocation.getInstance(getApplicationContext(), getIntent());

        // Build the config.
        Config config = new Config.Builder()
            .setDesiredAccuracy(0)
            .setDistanceFilter(50)            
            .setDebug(true)
            .setLogLevel(5)
            .setForegroundService(true)            
            .setUrl("http://your.server.com/endpoint")
            .setHeader("X-FOO", "FOO")
            .setHeader("X-BAR", "BAR")        
            .build();
        
        // Listen location event
        adapter.onMotionChange(new TSLocationCallback() {
            @Override
            public void onLocation(TSLocation location) {
                Log.i(TAG, "- [event] motionchange: " + location.toJson());
            }
            @Override
            public void onError(Integer code) {
                Log.i(TAG, "- [event] motionchange ERROR: " + code);
            }
        });
        // Listen to motionchange event
        adapter.onLocation(new TSLocationCallback() {
            @Override
            public void onLocation(TSLocation location) {
                Log.i(TAG, "- [event] location: " + location.toJson());
            }
            @Override
            public void onError(Integer code) {
                Log.i(TAG, "- [event] location ERROR: " + code);
            }
        });

        // Configure the plugin
        adapter.configure(config, new TSCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "- configure success");
                Config state = adapter.getConfig();
                if (!state.getEnabled()) {
                    adapter.start();
                }
            }

            @Override
            public void onFailure(String error) {
                TSLog.logger.debug("************** configure FAILURE: " + error);
            }
        });
    }
}
```


## :large_blue_diamond: [Advanced Demo Application for Field-testing](https://github.com/transistorsoft/rn-background-geolocation-demo)

A fully-featured [Demo App](https://github.com/transistorsoft/rn-background-geolocation-demo) is available in its own public repo.  After first cloning that repo, follow the installation instructions in the **README** there.  This demo-app includes a settings-screen allowing you to quickly experiment with all the different settings available for each platform.


# License

The MIT License (MIT)

Copyright (c) 2015 Chris Scott, Transistor Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


