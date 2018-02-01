# Android Installation

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

Create a folder in the root of your application project, eg: `/Libraries` and place the extracted **`background-geolocation`** folder into it:

eg: :open_file_folder: **`Libraries/background-geolocation-lt`**

## Gradle Configuration

### :open_file_folder: **`settings.gradle`**

```diff
+include ':background-geolocation'
+project(':background-geolocation').projectDir = new File(rootProject.projectDir, './Libraries/background-geolocation-lt/android/background-geolocation')
```

### :open_file_folder: **`android/build.gradle`**

```diff
allprojects {
    repositories {
+        google()
+        maven {
+            url project(':background-geolocation').projectDir.absolutePath + "/libs"
+        }
+    }
}

/**
-* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-* !!! THE FOLLOWING IS OPTIONAL BUT HIGHLY RECOMMENDED FOR YOUR SANITY !!!
-* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*
* Do you hate Gradle conflicts where other plugin require some particular
* version of play-services or define a compileSdkVersion, buildToolsVersion
* which conflicts with that of your app?  Me too!
*
* If you define these key gradle configuration variables globally, the 
* background-geolocation plugin (and any other "wise" plugins you've installed) 
* can align themselves to YOUR desired versions!  You should define these variables 
* as desired according to current values in your app/build.gradle
*
* You'll find that more and more plugins are beginning to wise up to checking 
* for the presense of global gradle variables like this.
*
* BackgroundGeolocation is aware of the following variables:
*/
+ext {
+    compileSdkVersion   = 26
+    targetSdkVersion    = 26
+    buildToolsVersion   = "26.0.2"
+    supportLibVersion   = "26.1.0"
+    playServicesVersion = "11.8.0" 
+}
-// BackgroundGeolocation is also aware of googlePlayServicesVersion if you prefer
```

### :open_file_folder: **`app/build.gradle`**

```diff
-/**
-* OPTIONAL:  If you've implemeted the "OPTIONAL BUT HIGHLY RECOMMENDED" note
-* above, you can define your compileSdkVersion, buildToolsVersion, targetSdkVersion 
-* using your own global variables as well:
-* Android Studio is smart enough to be aware of the evaulated values here,
-* to offer upgrade notices when applicable.
-*
-*/
android {
+    compileSdkVersion rootProject.compileSdkVersion
     defaultConfig {
+        targetSdkVersion rootProject.targetSdkVersion
         .
         .
         .
     }
     .
     .
     .
}

dependencies {
+    compile project(':background-geolocation')
+    implementation "com.android.support:appcompat-v7:$rootProject.supportLibVersion"    
}

```


## AndroidManifest.xml

### :open_file_folder: **`android/app/src/main/AndroidManifest.xml`**

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.transistorsoft.backgroundgeolocation.react">

  <application
    android:name=".MainApplication"
    android:allowBackup="true"
    android:label="@string/app_name"
    android:icon="@mipmap/ic_launcher"
    android:theme="@style/AppTheme">

    <!-- react-native-background-geolocation licence -->
+   <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>

```

:information_source: [Purchase a License](http://www.transistorsoft.com/shop/products/react-native-background-geolocation)

## Proguard Config

:open_file_folder: **`android/app/proguard-rules.pro`**

```proguard
# BackgroundGeolocation
-keep class com.transistorsoft.** { *; }
-dontwarn com.transistorsoft.**

-keep class com.google.**
-dontwarn com.google.**
-dontwarn org.apache.http.**
-dontwarn com.android.volley.toolbox.**

# BackgroundGeolocation (EventBus)
-keepclassmembers class * extends de.greenrobot.event.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}
-keepattributes *Annotation*
-keepclassmembers class ** {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}

# logback
-keep class ch.qos.** { *; }
-keep class org.slf4j.** { *; }
-dontwarn ch.qos.logback.core.net.*
```
