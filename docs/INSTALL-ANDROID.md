# Android Installation

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

Create a folder in the root of your application project, eg: `/Libraries` and place the extracted **`background-geolocation`** folder into it:

eg: :open_file_folder: **`Libraries/background-geolocation-lt`**

## Gradle Configuration

:open_file_folder: **`settings.gradle`**

```diff
+include ':background-geolocation'
+project(':background-geolocation').projectDir = new File(rootProject.projectDir, './Libraries/background-geolocation-lt/android/background-geolocation')

```

:open_file_folder: **`app/build.gradle`**

```diff
+repositories {
+    flatDir {
+        dirs project(':background-geolocation').projectDir.absolutePath + "/libs"
+    }
+}

dependencies {
+    compile project(':background-geolocation')
}
```

:information_source: If you have a different play-serivces than the one included in this library, use the following instead (switch **`11.8.0`** for *your* desired version):

```diff
dependencies {
     .
     .
     .
+    compile(project(':background-geolocation')) {     
+        exclude group: 'com.google.android.gms', module: 'play-services-location'
+    }
     // Now force your desired version
+    compile 'com.google.android.gms:play-services-location:11.8.0'
}
```

## AndroidManifest.xml

:open_file_folder: **`android/app/src/main/AndroidManifest.xml`**

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
