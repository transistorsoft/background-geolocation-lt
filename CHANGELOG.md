# Change Log

## [1.4.0] - 2020-06-17

- [Fixed][Android] `com.android.tools.build:gradle:4.0.0` no longer allows "*direct local aar dependencies*".  The Android Setup now requires a custom __`maven url`__ to be added to your app's root __`android/build.gradle`__:\

:open_file_folder: `android/build.gradle`:

```diff
allprojects {
    repositories {
        google()
        jcenter()
+       maven {
+           url("${project(':background-geolocation').projectDir}/libs")
+       }
    }
}
```

- [Fixed][Android] `onConnectivityChange` can report incorrect value for `enabled` when toggling between Wifi Off / Airplane mode.
- [Fixed][Android] `onGeofence` event-handler fails to be fired when `maxRecordsToPersist: 0`.
- [Fixed][Android] `requestPermission` method was always returning `AUTHORIZATION_STATUS_ALWAYS` even when *When in Use* was selected.
- [Fixed][iOS] When using `disableStopDetection: true` with `pausesLocationUpdatesAutomatically: true`, the `CLLocationManagerDelegate didPauseLocationUpdates` the `motionchange` event reported `isMoving: true`.
- [Fixed][Android] Ensure location failure callback is executed on main-thread.

## [1.3.0] - 2020-05-07

- [Added] New method `BackgroundGeolocation.destroyLocation(uuid)` for destroying a single location by `Location.uuid`.
- [Fixed] Allow firebase-adapter to validate license flavors on same key (eg: .development, .staging).
- [Fixed] iOS geofence listeners on `onGeofence` method *could possibly* fail to be called when a geofence event causes iOS to re-launch the app in the background (this would **not** prevent the plugin posting the geofence event to your `Config.url`, only a failure of the Javascript `onGeofence` to be fired).
- [Changed] Android library `tslocationmanager.aar` is now compiled using `androidx`.  For backwards-compatibility with those how haven't migrated to `androidX`, a *reverse-jetified* build is included.  Usage is detected automatically based upon `android.useAndroidX` in one's `gradle.properties`.
- [Added] [Android] Add new `Config.motionTriggerDelay (milliseconds)` for preventing false-positive triggering of location-tracking (while walking around one's house, for example).  If the motion API triggers back to `still` before `motionTriggerDelay` expires, triggering to the *moving* state will be cancelled.
- [Fixed] Address issue with rare reports of iOS crashing with error referencing `SOMotionDetector.m`.
- [Fixed] Odometer issue with Android/iOS:  Do not persist `lastOdometerLocation` when plugin is disabled.
- [Added] [Android] Add an boolean extra `TSLocationManager: true` to the launch Intent of the foreground-notification, allowing application developers to determine when their app was launched due to a click on the foreground-notification.
- [Fixed] `Authorization` bug in refresh-url response-data recursive iterator.  Do not recurse into arrays in token-refresh response from server (`tokens` are not likely to be found there, anyway).
- [Added] iOS `Config.showsBackgroundLocationIndicator`, A Boolean indicating whether the status bar changes its appearance when an app uses location services in the background.
- [Changed] `react-native-background-fetch` dependency updated to `3.x` with new iOS 13 `BGTaskScheduler` API.
- [Fixed] iOS bug related to significant-location-changes (SLC) API.  In a previous version, the plugin's geofence manager would stop monitoring SLC if the number of added geofences was < the maximum (20) (in order to not show the new iOS 13 dialog reporting background location usage when infinite-geofencing is not required).  The background-geolocation SDK uses several `CLLocationManager` instances and its `GeofenceManager` maintains its own instance.  However, it turns out that when *any* `CLLocationManager` instance stops monitoring the SLC API, then **ALL** instances stop monitoring SLC, which is highly unexpected and undocumented.  As a result, the plugin would lose its safety mechanism should the stationary geofence fail to trigger and iOS tracking could fail to start in some circumstances.
- [Fixed] `synchronize` methods in `TSLocationManager` to address Android NPE related to `buildTSLocation`.
- [Fixed] Typescript declaration for `Location.isMoving` should be `Location.is_moving`.
- [Fixed] iOS:  Bug in `accessToken` RegExp in Authorization token-refresh handler.
- [Added] Implement four new RPC commands `addGeofence`, `removeGeofence`, `addGeofences`, `removeGeofences`.  Document available RPC commands in "HttpGuide".
- [Changed] Upgrade `BackgroundFetch` to use latest `BGTaskScheduler` API.

## [1.2.0] - 2020-01-14
- [Fixed] Android: launch-Intent for foreground-service notification was causing notification-click to re-launch the Activity rather than show existing.
- [Changed] Android: Modify behaviour of geofences-only mode to not periodically request location-updates.  Will use a stationary-geofence of radius geofenceProximityRadius/2 as a trigger to re-evaluate geofences in proximity.
- [Changed] iOS: Prefix FMDB method-names `databasePool` -> `ts_databasePool` after reports of apps being falsely rejected by Apple for "private API usage".
- [Fixed] Android: Ensure that `location.hasSpeed()` before attempting to use it for distanceFilter elasticity calculations.  There was a report of a Device returning `Nan` for speed.
- [Fixed] Android:  Do not throttle http requests after http connect failure when configured with `maxRecordsToPersist`.
- [Fixed] Android: Respect `disableLocationAuthorizationAlert` for all cases, including `getCurrentPosition`.
- [Changed] Android: Modify behaviour of geofences-only mode to not periodically request location-updates.  Will use a stationary-geofence of radius geofenceProximityRadius/2 as a trigger to re-evaluate geofences in proximity.
- [Changed] Authorization refreshUrl will post as application/x-www-form-urlencoded instead of form/multipart
- [Changed] iOS geofencing mode will not engage Significant Location Changes API when total geofence count <= 18 in order to prevent new iOS 13 "Location summary" popup from showing frequent location access.
- [Fixed] Android:  Add hack for older devices to fix "GPS Week Rollover" bug where incorrect timestamp is recorded from GPS (typically where year is older by 20 years).
- [Fixed] When determining geofences within `geofenceProximityRadius`, add the `location.accuracy` as a buffer against low-accuracy locations.
- [Changed] Increase default `geofenceProximityRadius: 2000`.

## [1.1.0] - 2019-12-05
- [Added] New `Config.authorization` option for automated authorization-token support.  If the SDK receives an HTTP response status `401 Unauthorized` and you've provided an `authorization` config, the plugin will automatically send a request to your configured `refreshUrl` to request a new token.  The SDK will take care of adding the required `Authorization` HTTP header with `Bearer accessToken`.  In the past, one would manage token-refresh by listening to the SDK's `onHttp` listener for HTTP `401`.  This can now all be managed by the SDK by providing a `Config.authorization`.
- [Added] Implemented strong encryption support via `Config.encrypt`.  When enabled, the SDK will encrypt location data in its SQLite datbase, as well as the payload in HTTP requests.  See API docs `Config.encrypt` for more information, including the configuration of encryption password.
- [Added] New JSON Web Token API for the Demo server at http://tracker.transistorsoft.com.  It's now easier than ever to configure the plugin to post to the demo server.
- [Added] New `DeviceInfo` module for providing simple device-info (`model`, `manufacturer`, `version`, `platform`).
- [Fixed] Android NPE
```
Caused by: java.lang.NullPointerException:
  at com.transistorsoft.locationmanager.service.TrackingService.b (TrackingService.java:172)
  at com.transistorsoft.locationmanager.service.TrackingService.onStartCommand (TrackingService.java:135)
```
- [Added] new `uploadLog` feature for uploading logs directly to a server.  This is an alternative to `emailLog`.
- [Changed] All logging methods (`getLog`, `emailLog` and `uploadLog`) now accept an optional `SQLQuery`.
- [Fixed] Android: Fixed issue executing `#changePace` immediately after `#start`.
- [Fixed] Android:  Add guard against NPR in `calculateMedianAccuracy`
- [Added] Add new Geofencing methods: `#getGeofence(identifier)` and `#geofenceExists(identifier)`.

## [1.0.4] - 2019-10-07
- [Fixed] Resolved a number of Android issues exposed by booting the app in [StrictMode](https://developer.android.com/reference/android/os/StrictMode).  This should definitely help alleviate ANR issues related to `Context.startForegroundService`.

## [1.0.3] - 2019-10-04
- [Added] Android now supports `disableMotionActivityUpdates` for Android 10 which now requires run-time permission for "Physical Activity".  Setting to `true` will not ask user for this permission.  The plugin will fallback to using the "stationary geofence" triggering, like iOS.
- [Changed] Android:  Ensure all code that accesses the database is performed in background-threads, including all logging (addresses `Context.startForegroundService` ANR issue).
- [Changed] Android:  Ensure all geofence event-handling is performed in background-threads (addresses `Context.startForegroundService` ANR issue).
- [Added] Android: implement logic to handle operation without Motion API on Android 10.  v3 has always used a "stationary geofence" like iOS as a fail-safe, but this is now crucial for Android 10 which now requires run-time permission for "Physical Activity".  For those users who [Deny] this permission, Android will trigger tracking in a manner similar to iOS (ie: requiring movement of about 200 meters).  This also requires handling to detect when the device has become stationary.

## [1.0.2] - 2019-09-25
- [Changed] Android:  move more location-handling code into background-threads to help mitigate against ANR referencing `Context.startForegroundService`
- [Changed] Android:  If BackgroundGeolocation adapter is instantiated headless and is enabled, force ActivityRecognitionService to start.
- [Added] Add `mock` to `locationTemplate` data.

## [1.0.1] - 2019-09-05

- [Changed] Android now hosts its own `proguard-rules.pro`.  See Android setup docs for new integration of plugin's required Proguard Rules into your app.
- [Changed] Rebuild iOS `TSLocationManager.framework` with XCode 10 (previous build used XCode 11-beta6).  Replace `@available` macro with `SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO`.
- [Fixed] iOS 13 preventSuspend was not working with iOS 13.  iOS has once again decreased the max time for UIApplication beginBackgroundTask from 180s down to 30s.
- [Changed] Upgrade `android-logback` dependency to `2.0.0`
- [Changed] Android: move some plugin initialization into background-threads (eg: `performLogCleanup`) to help mitigate against ANR "`Context.startForegroundService` did not then call `Service.startForeground`".

## [1.0.0] - 2019-08-21
------------------------------------------------------------------------------
### :warning: Breaking Changes

#### [Changed] The license format has changed.  New `1.0.0` licenses are now available for customers in the [product dashboard](https://www.transistorsoft.com/shop/customers).
![](https://dl.dropbox.com/s/3ohnvl9go4mi30t/Screenshot%202019-03-26%2023.07.46.png?dl=1)

- For versions `< 1.0.0`, use *old* license keys.
- For versions `>= 1.0.0`, use *new* license keys.

- [Changed] Major refactor of Android Service architecture.  The SDK no longer requires a foreground-service active at all times.  The foreground-service (and cooresponding persistent notification) will only be active while the SDK is in the *moving* state.  No breaking dart api changes.
- [Changed] Improved Android debug notifications.

- [Added] Added new Config options `persistMode` for specifying exactly which events get persisted: location | geofence | all | none.
- [Added] Experimental Android-only Config option `speedJumpFilter (default 300 meters/second)` for detecting location anomalies.  The plugin will measure the distance and apparent speed of the current location relative to last location.  If the apparent speed is > `speedJumpFilter`, the location will be ignored.  Some users, particularly in Australia, curiously, have had locations suddenly jump hundreds of kilometers away, into the ocean.
- [Changed] iOS and Android will not perform odometer updates when the calculated distance is less than the average accuracy of the current and previous location.  This is to prevent small odometer changes when the device is lingering around the same position.

- [Added] New `DeviceSettings` API for redirecting user to Android Settings screens, including vendor-specific screens (eg: Huawei, OnePlus, Xiaomi, etc).  This is an attempt to help direct the user to appropriate device-settings screens for poor Android vendors as detailed in the site [Don't kill my app](https://dontkillmyapp.com/).
- [Added] `schedule` can now be configured to optionally execute geofences-only mode (ie: `#startGeofences`) per schedule entry.  See `schedule` docs.
- [Changed] Update Gradle config to use `implementation` instead of deprecated `compile`
- **[BREAKING]** Change Gradle `ext` configuration property `googlePlayServicesVersion` -> `googlePlayServicesLocationVersion`.  Now that Google has decoupled all their libraries, `play-services:location` now has its own version, independant of all other libs.

`android/build.gradle`:
```diff
buildscript {
    ext {
        buildToolsVersion = "28.0.3"
        minSdkVersion = 16
        compileSdkVersion = 28
        targetSdkVersion = 27
        supportLibVersion = "28.0.0"
-       googlePlayServicesVersion = "16.0.0"
+       googlePlayServicesLocationVersion = "16.0.0"
    }
}
```

### New Features

- [Added] Android implementation for `useSignificantChangesOnly` Config option.  Will request Android locations **without the persistent foreground service**.  You will receive location updates only a few times per hour:

#### `useSignificantChangesOnly: true`:
![](https://dl.dropboxusercontent.com/s/wdl9e156myv5b34/useSignificantChangesOnly.png?dl=1)

#### `useSignificantChangesOnly: false`:
![](https://dl.dropboxusercontent.com/s/hcxby3sujqanv9q/useSignificantChangesOnly-false.png?dl=1)

- [Added] Android now implements a "stationary geofence", just like iOS.  It currently acts as a secondary triggering mechanism along with the current motion-activity API.  You will hear the "zap" sound effect when it triggers.  This also has the fortunate consequence of allowing mock-location apps (eg: Lockito) of being able to trigger tracking automatically.

- [Added] The SDK detects mock locations and skips trigging the `stopTimeout` system, improving location simulation workflow.
- [Added] Android-only Config option `geofenceModeHighAccuracy` for more control over geofence triggering responsiveness.  Runs a foreground-service during geofences-only mode (`#startGeofences`).  This will, of course, consume more power.

#### `geofenceModeHighAccuracy: false` (Default)

- Transition events are delayed in favour of lower power consumption.

![](https://dl.dropboxusercontent.com/s/6nxbuersjcdqa8b/geofenceModeHighAccuracy-false.png?dl=1)

#### `geofenceModeHighAccuracy: true`

- Transition events are nearly instantaneous at the cost of higher power consumption.

![](https://dl.dropbox.com/s/w53hqn7f7n1ug1o/geofenceModeHighAccuracy-true.png?dl=1)

- [Added] Android implementation of `startBackgroundTask` / `stopBackgroundTask`.

Logging for Android background-tasks looks like this (when you see an hourglass, a foreground-service is active)
```
 [BackgroundTaskManager onStartJob] ⏳ startBackgroundTask: 6
 .
 .
 .
 [BackgroundTaskManager$Task stop] ⏳ stopBackgroundTask: 6
```
- [Added] New custom Android debug sound FX.  See the [Config.debug](https://transistorsoft.github.io/cordova-background-geolocation/interfaces/_cordova_background_geolocation_.config.html#debug) for a new decription of iOS / Android sound FX **including a media player to play each.**
![](https://dl.dropbox.com/s/zomejlm9egm1ujl/Screenshot%202019-03-26%2023.10.50.png?dl=1)

### Removed
- [Changed] Removed Android config option **`activityRecognitionInterval`** and **`minimumActivityRecognitionConfidence`**.  The addition of the new "stationary geofence" for Android should alleviate issues with poor devices failing to initiate tracking.  The Android SDK now uses the more modern [ActivityTransistionClient](https://medium.com/life360-engineering/beta-testing-googles-new-activity-transition-api-c9c418d4b553) API which is a higher level wrapper for the traditional [ActivityReconitionClient](https://developers.google.com/android/reference/com/google/android/gms/location/ActivityRecognitionClient).  `AcitvityTransitionClient` does not accept a polling `interval`, thus `actiivtyRecognitionInterval` is now unused.  Also, `ActivityTransitionClient` emits similar `on_foot`, `in_vehicle` events but no longer provides a `confidence`, thus `confidence` is now reported always as `100`.  If you've been implementing your own custom triggering logic based upon `confidence`, it's now pointless.  The `ActivityTransitionClient` will open doors for new features based upon transitions between activity states.

```
╔═════════════════════════════════════════════
║ Motion Transition Result
╠═════════════════════════════════════════════
╟─ 🔴  EXIT: walking
╟─ 🎾  ENTER: still
╚═════════════════════════════════════════════
```

- [Changed] Android: `setShowBadge(false)` on Android `NotificationChannel`.  Some users reporting that Android shows a badge-count on app icon when service is started / stopped.
- [Added] Added method `getProviderState` for querying current state of location-services.
- [Added] Added method `requestPermission` for manually requesting location-permission (`#start`, `#getCurrentPosition`, `#watchPosition` etc, will already automatically request permission.
- [Changed] Upgrade Android logger dependency to latest version (`logback`).
- [Fixed] Prevent Android foreground-service from auto-starting when location permission is revoked via Settings screen.
- [Fixed] NPE in Android HTTP Service when manual sync is called.  Probably a threading issue with multiple sync operations executed simultaneously.

## [0.2.0] - 2018-10-30
- [Added] Android SDK 28 requires new permission to use foreground-service.
- [Fixed] Android `NullPointerException` on `WatchPositionCallback` with `watchPosition`.
- [Fixed] iOS Catch `NSInvalidArgumentException` when decoding `TSConfig`.
- [Fixed] iOS scheduler not being initialized in `#ready` after reboot.
- [Changed] Android headless events are now posted with using `EventBus` instead of `JobScheduler`.  Events posted via Android `JobScheduler` are subject to time-slicing by the OS so events could arrive late.

## [0.1.1] - 2018-06-26

- [Added] iOS support for HTTP method `PATCH` (Android already supports it).
- [Fixed] Android was not using `httpTimeout` with latest `okhttp3`.
- [Fixed] Android issue not firing `providerchange` on boot when configured with `stopOnTerminate: true`
- [Fixed] Android `httpTimeout` was not being applied to new `okhttp3.Client#connectionTimeout`
- [Fixed] Apply recommended XCode build settings.
- [Fixed] XCode warnings 'implicity retain self in block'
- [Changed] Android Removed unnecessary attribute `android:supportsRtl="true"` from `AndroidManifest`
- [Fixed] iOS `preventSuspend` was not working with `useSignificantChangesOnly`
- [Changed] iOS disable encryption on SQLite database file when "Data Protection" capability is enabled with `NSFileProtectionNone` so that plugin can continue to insert records while device is locked.
- [Fixed] iOS issue when plugin is booted in background in geofences-only mode, could engage location-tracking mode.
- [Fixed] Android `getCurrentPosition` was not respecting `persist: true` when executed in geofences-only mode.
- [Fixed] iOS geofence exit was being ignored in a specific case where (1) geofence was configured with `notifyOnDwell: true` AND (2) the app was booted in the background *due to* a geofence exit event.

## [0.1.0] - 2018-04-30
