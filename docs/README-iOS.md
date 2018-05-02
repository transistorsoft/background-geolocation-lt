# :books: iOS API Documentation
### :wrench: [Configuration Options](#wrench-configuration-options-1)
  + [Geolocation Options](#wrench-geolocation-options)    
  + [Activity Recognition Options](#wrench-activity-recognition-options)    
  + [HTTP & Persistence Options](#wrench-http--persistence-options)
  + [Geofencing Options](#wrench-geofencing-options)
  + [Application Options](#wrench-application-options)   
  + [Logging &amp; Debug Options](#wrench-logging--debug-options) 
### :zap: [Events](#zap-events-1)
### :small_blue_diamond: [Methods](#large_blue_diamond-methods)
  + [Core API Methods](#small_blue_diamond-core-api-methods)
  + [HTTP & Persistence Methods](#small_blue_diamond-http--persistence-methods)
  + [Geofencing Methods](#small_blue_diamond-geofencing-methods)
  + [Logging Methods](#small_blue_diamond-logging-methods)
### :blue_book: Guides
  + [Philosophy of Operation](../../../wiki/Philosophy-of-Operation)
  + [Geofencing](geofencing.md)
  + [HTTP Features](http.md)
  + [Android Headless Mode](../../..//wiki/Android-Headless-Mode)
  + [Location Data Schema](../../../wiki/Location-Data-Schema)
  + [Debugging](../../../wiki/Debugging)

# :wrench: Configuration Options

The following **Options** can all be provided to the plugin's `TSConfig` instance.

```obj-c

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TSConfig *config = [TSConfig sharedInstance];
          
    [config updateWithBlock:^(TSConfigBuilder *builder) {
        builder.debug = YES;
        builder.desiredAccuracy = kCLLocationAccuracyBest;
        build.distanceFilter = 10;
        builder.stopOnTerminate = NO;
        builder.startOnBoot = YES;
        builder.url = @"http://your.server.com/locations";
        builder.params = @{@"foo":@"bar"};
        builder.headers = @{@"X-FOO":@"FOO", @"X-BAR":@"BAR"};
        builder.autoSync = YES;
    }];

    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

    // Required.
    [bgGeo ready];

    if (!config.enabled) {      
        [bgGeo start];
    }
}
```

## :wrench: Geolocation Options


| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`desiredAccuracy`](#config-cllocationaccuracy-desiredaccuracy-kcllocationaccuracybest) | `CLLocationAccuracy` | `kCLLocationAccuracyBest` | Specify the desired-accuracy of the geolocation system. |
| [`distanceFilter`](#config-cllocationdistance-distancefilter-10) | `CLLocationDistance` | `10` | The minimum distance (measured in meters) a device must move horizontally before an update event is generated. |
| [`stationaryRadius`](#config-cllocationdistance-stationaryradius-25) | `CLLocationDistance`  | `25`  | When stopped, the minimum distance the device must move beyond the stationary location for aggressive background-tracking to engage. |
| [`disableElasticity`](#config-bool-disableelasticity-no) | `BOOL` | `NO` | Set true to disable automatic speed-based #distanceFilter elasticity. eg: When device is moving at highway speeds, locations are returned at ~ 1 / km. |
| [`elasticityMultiplier`](#config-double-elasticitymultiplier-1) | `double` | `1` | Controls the scale of automatic speed-based `distanceFilter` elasticity.  Increasing `elasticityMultiplier` will result in few location samples as speed increases. |
| [`stopAfterElapsedMinutes`](#config-double-stopafterelapsedminutes--1) | `double`  | `0`  | The plugin can optionally automatically stop tracking after some number of minutes elapses after the [`#start`](#start) method was called. |
| [`stopOnStationary`](#config-bool-stoponstationary-no) | `BOOL`  | `NO`  | The plugin can optionally automatically `#stop` tracking when the `stopTimeout` timer elapses. |
| [`desiredOdometerAccuracy`](#config-cllocationaccuracy-desiredodometeraccuracy-100) | `CLLocationAccuracy`  | `100`  | Location accuracy threshold in **meters** for odometer calculations. |
| [`useSignificantChangesOnly`](#config-bool-usesignificantchangesonly-no) | `BOOL` | `NO` | Defaults to `NO`.  Set `YES` in order to disable constant background-tracking and use only the iOS [Significant Changes API](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/index.html#//apple_ref/occ/instm/CLLocationManager/startMonitoringSignificantLocationChanges). |
| [`locationAuthorizationRequest`](#config-nsstring-locationauthorizationrequest-always) | `NSString` | `Always` | The desired iOS location-authorization request, either `Always` or `WhenInUse`. |
| [`locationAuthorizationAlert`](#config-nsdictionary-locationauthorizationalert) | `NSDictionary` | `@{}` | When you configure the plugin [`locationAuthorizationRequest`](config-string-locationauthorizationrequest-always) `Always` or `WhenInUse` and the user *changes* that value in the app's location-services settings or *disables* location-services, the plugin will display an Alert directing the user to the **Settings** screen. |

## :wrench: Activity Recognition Options


| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`activityRecognitionInterval`](#config-double-millis-10000-activityrecognitioninterval) | `double` | `10000` | The desired time between activity detections. Larger values will result in fewer activity detections while improving battery life. A value of `0` will result in activity detections at the fastest possible rate. |
| [`stopTimeout`](#config-double-stoptimeout-5) | `double` | `5`  | The number of **minutes** to wait before turning off location-services after the ActivityRecognition System (ARS) detects the device is `STILL` |
| [`minimumActivityRecognitionConfidence`](#config-nsinteger-minimumactivityrecognitionconfidence-75) | `NSInteger` | `75` | Each activity-recognition-result returned by the API is tagged with a "confidence" level expressed as a `%`.  You can set your desired confidence to trigger a state-change.|
| [`stopDetectionDelay`](#config-double-stopdetectiondelay-0) | `double` | `0` | Number of **minute** to delay the stop-detection system from being activated.  Default is no delay.| 
| [`disableStopDetection`](#config-bool-disablestopdetection-no) | `BOOL` | `NO` | Disable accelerometer-based **Stop-detection System**. :warning: Not recommended|
| [`activityType`](#config-clactivitytype-activitytype-clactivitytypeother) | `CLActivityType` |  `CLActivityTypeOther` | Presumably, this affects ios GPS algorithm.  See [Apple docs](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html#//apple_ref/occ/instp/CLLocationManager/activityType) for more information |
| [`disableMotionActivityUpdates`](#config-bool-disablemotionactivityupdates-no) | `BOOL` | `NO` | Disable iOS motion-activity updates (eg: "walking", "in_vehicle").  This feature requires a device having the **M7** co-processor (ie: iPhone 5s and up). :warning: The plugin is **HIGHLY** optimized to use this for improved battery performance.  You are **STRONLY** recommended to **NOT** disable this. |


## :wrench: HTTP & Persistence Options

:blue_book: [HTTP Guide](http.md)

| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`url`](#config-nsstring-url-) | `NSString` | `""` | Your server url where you wish to HTTP POST locations to |
| [`httpTimeout`](#config-nsinteger-httptimeout-60000) | `NSInteger` | `60000` | HTTP request timeout in milliseconds. |
| [`params`](#config-nsdictionary-params) | `NSDictionary` | `null` | Optional HTTP params sent along in HTTP request to above [`#url`](#config-string-url-undefined) |
| [`extras`](#config-nsdictionary-extras) | `NSDictionary` | `null` | Optional meta-data to attach to *each* recorded location |
| [`headers`](#config-nsdictionary-headers) | `NSDictionary` | `null` | Optional HTTP headers sent along in HTTP request to above [`#url`](#config-string-url-undefined) |
| [`method`](#config-nsstring-method-post) | `NSString` | `POST` | The HTTP method.  Defaults to `POST`.  Some servers require `PUT`.|
| [`httpRootProperty`](#config-nsstring-httprootproperty-location) | `NSString` | `location` | The root property of the JSON data where location-data will be appended. |
| [`locationTemplate`](#config-nsstring-locationtemplate-undefined) | `NSString` | `undefined` | Optional custom location data schema (eg: `{ "lat:<%= latitude %>, "lng":<%= longitude %> }`|
| [`geofenceTemplate`](#config-nsstring-geofencetemplate-undefined) | `NSString` | `undefined` | Optional custom geofence data schema (eg: `{ "lat:<%= latitude %>, "lng":<%= longitude %>, "geofence":"<%= geofence.identifier %>:<%= geofence.action %>" }`|
| [`autoSync`](#config-bool-autosync-yes) | `BOOL` | `YES` | If you've enabeld HTTP feature by configuring an [`#url`](#config-string-url-undefined), the plugin will attempt to upload each location to your server **as it is recorded**.|
| [`autoSyncThreshold`](#config-nsinteger-autosyncthreshold-0) | `NSInteger` | `0` | The minimum number of persisted records to trigger an [`#autoSync`](#config-string-autosync-true) action. |
| [`batchSync`](#config-bool-batchsync-no) | `BOOL` | `NO` | If you've enabled HTTP feature by configuring an [`#url`](config-nsstring-url-undefined), [`batchSync: true`](#config-bool-batchsync-no) will POST all the locations currently stored in native SQLite datbase to your server in a single HTTP POST request.|
| [`maxBatchSize`](#config-nsinteger-maxbatchsize--1) | `NSInteger` | `-1` | If you've enabled HTTP feature by configuring an [`#url`](config-nsstring-url-undefined) and [`batchSync: true`](#config-bool-batchsync-no), this parameter will limit the number of records attached to each batch.|
| [`maxDaysToPersist`](#config-nsinteger-maxdaystopersist-1) | `NSInteger` |  `1` |  Maximum number of days to store a geolocation in plugin's SQLite database.|
| [`maxRecordsToPersist`](#config-nsinteger-maxrecordstopersist--1) | `NSInteger` |  `-1` |  Maximum number of records to persist in plugin's SQLite database.  Defaults to `-1` (no limit).  To disable persisting locations, set this to `0`|
| [`locationsOrderDirection`](#config-nsstring-locationsorderdirection-asc) | `String` |  `ASC` |  Controls the order that locations are selected from the database (and synced to your server).  Defaults to ascending (`ASC`), where oldest locations are synced first.  Descending (`DESC`) syncs latest locations first.|


## :wrench: Application Options

| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`stopOnTerminate`](#config-bool-stoponterminate-yes) | `BOOL` |  `YES` | Set `NO` to continue tracking after user teminates the app. |
| [`startOnBoot`](#config-bool-startonboot-no) | `BOOL` | `NO` | Set to `YES` to enable background-tracking after the device reboots. |
| [`heartbeatInterval`](#config-nstimeinterval-heartbeatinterval-60) | `NSTimeInterval` | `60` | Rate in **seconds** to fire [`heartbeat`](#heartbeat) events. |
| [`schedule`](#config-nsarray-schedule-undefined) | `NSArray` | `undefined` | Defines a schedule to automatically start/stop tracking at configured times |
| [`preventSuspend`](#config-bool-preventsuspend-no) | `BOOL` | `NO` | Enable this to prevent **iOS** from suspending your app in the background while in the **stationary state**.  Must be used in conjunction with a [`#heartbeatInterval`](config-nstimeinterval-heartbeatinterval-60).|


## :wrench: Geofencing Options

:blue_book: [Geofencing Guide](geofencing.md)

| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`geofenceProximityRadius`](#config-cllocationdistance-geofenceproximityradius-1000) | `CLLocationDistance`  | `1000`  | Radius in **meters** to query for geofences within proximity. |
| [`geofenceInitialTriggerEntry`](#config-bool-geofenceinitialtriggerentry-yes) | `BOOL` | `YES` | Set `NO` to disable triggering a geofence immediately if device is already inside it.|


## :wrench: Logging & Debug Options

:blue_book: [Logging & Debugging Guide](../../../wiki/Debugging)

| Option      | Type      | Default   | Note                              |
|-------------|-----------|-----------|-----------------------------------|
| [`debug`](#config-bool-debug-no) | `BOOL` | `false` | When enabled, the plugin will emit sounds & notifications for life-cycle events of background-geolocation |
| [`logLevel`](#config-tsloglevel-loglevel-tslogleveloff) | `TSLogLevel` | `tsLogLevelOff` | Sets the verbosity of the plugin's logs from `tsLogLevelOff` to `tsLogLevelVerbose` |
| [`logMaxDays`](#config-nsinteger-logmaxdays-3) | `NSInteger` | `3` | Maximum days to persist a log-entry in database. |


# :zap: Events

### Adding event-listeners

Event-listeners can be attached using the method **`#on{EventName}`**, supplying the **Event Name** in the following table.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo onLocation:^(TSLocation *tsLocation) {
    CLLocation location = tsLocation.location;
    NSLog(@"- onLocation: %@, %@", location, [tsLocation toDictionary]);
} failure:^(NSError *error) {
    NSLog(@"- onLocation error: %@", error);
}];
```

### Removing event-listeners: `#un`

Event-listeners are removed with the method **`#un`**.  You must supply a reference to the *exact* `successFn` reference used with the **`#on{EventName}`** method:

```obj-c
// Create callback blocks
onLocation = ^void(TSLocation *location) {
    NSLog(@"- Location: %@", location);
};
onLocationError = ^void(NSError *error) {
    NSLog(@"- Location error: %@", error);
};

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

// Add listener
[bgGeo onLocation:onLocation failure:onLocationError];

// Remove listener by supplying only the success callback
[bgGeo un:@"location" callback:onLocation];

```

| Event Name         | Description                                     |
|--------------------|-------------------------------------------------|
| [`location`](#location) | Fired whenever a new location is recorded. |
| [`motionchange`](#motionchange) | Fired when the device changes state between **stationary** and **moving** |
| [`activitychange`](#activitychange) | Fired when the activity-recognition system detects a *change* in detected-activity (`still, on_foot, in_vehicle, on_bicycle, running`) |
| [`providerchange`](#providerchange)| Fired when a change in the state of the device's **Location Services** has been detected.  eg: "GPS ON", "Wifi only".|
| [`geofence`](#geofence) | Fired when a geofence crossing event occurs. |
| [`geofenceschange`](#geofenceschange) | Fired when the list of monitored geofences within [`#geofenceProximityRadius`](#config-cllocationdistance-geofenceproximityradius-1000) changed|
| [`http`](#http) | Fired after a successful HTTP response. `response` object is provided with `status` and `responseText`. |
| [`heartbeat`](#heartbeat) | Fired each [`#heartbeatInterval`](#config-integer-heartbeatinterval-undefined) while the plugin is in the **stationary** state with.  Your callback will be provided with a `params {}` containing the last known `location {Object}` |
| [`schedule`](#schedule) | Fired when a schedule event occurs.  Your `callbackFn` will be provided with the current **`state`** Object. | 
| [`powersavechange`](#powersavechange) | Fired when the state of the operating-system's "Power Saving" system changes.  Your `callbackFn` will be provided with a `Boolean` showing whether "Power Saving" is **enabled** or **disabled** | 
| [`connectivitychange`](#connectivitychange) | Fired when the state of the device's network connectivity changes (enabled -> disabled and vice-versa) |
| [`enabledchange`](#enabledchange) | Fired when the plugin's `enabled` state changes.  For example, executing `#start` and `#stop` will fire the `enabledchange` event. | 



# :large_blue_diamond: Methods

### :small_blue_diamond: Core API Methods

| Method Name      | Arguments       | Notes                                |
|------------------|-----------------|--------------------------------------|
| [`ready`](#ready) |                | Signal to the plugin that your app is booted and ready |
| [`start`](#start) |  | Enable location & geofence tracking.  This is the plugin's power **ON** button. |
| [`stop`](#stop) |  | Disable location & geofence tracking.  This is the plugin's power **OFF** button. |
| [`getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest) | `TSCurrentPositionRequest` | Retrieves the current position using maximum power & accuracy by fetching a number of samples and returning the most accurate to your **`callbackFn`**.|
| [`watchPosition`](#watchpositiontswatchpositionrequest) | `TSWatchPositionRequest` | Start a stream of continuous location-updates. |
| [`stopWatchPosition`](#stopwatchposition) |  | Halt [`#watchPosition`](#watchpositiontswatchpositionrequest) updates. |
| [`changePace`](#changepacebool) | `BOOL` | Toggles the plugin's state between **stationary** and **moving**. |
| [`getOdometer`](#cllocationdistance-getodometer) |  | The plugin constantly tracks distance travelled.  Returns the current **`distance`** (meters)|
| [`setOdometer`](#setodometercllocationdistance-requesttscurrentpositionrequest) | `CLLocationDistance`, `TSCurrentPositionRequest` | Set the `odometer` to *any* arbitrary value.  **NOTE** `setOdometer` will perform a `getCurrentPosition` in order to record to exact location where odometer was set; as a result, the `callback` signatures are identical to those of `getCurrentPosition`.|
| [`startSchedule`](#startschedule) |  | If a [`schedule`](#config-array-schedule-undefined) was configured, this method will initiate that schedule.|
| [`stopSchedule`](#stopschedule) |  | This method will stop the Scheduler service. |
| [`removeListeners`](#removelisteners) |  | Remove all events-listeners registered with **`#on{EventName}`** method |
| [`createBackgroundTask`](#uibackgroundtaskidentifier-createbackgroundtask) |  | Sends a signal to the native OS that you wish to perform a long-running task.  Returns an `UIBackgroundTaskIdentifier`.  The OS will not suspend your app until you signal completion with the **`#finish`** method.|
| [`stopBackgroundTask`](#stopbackgroundtaskuibackgroundtaskidentifier) | `taskId` | Sends a signal to the native OS the supplied **`taskId`** is complete and the OS may proceed to suspend your application if applicable.|
| [`isPowerSaveMode`](#bool-ispowersavemode) | | Fetches the state of the operating-systems "Power Saving" mode, whether `enabled` or `disabled`|


### :small_blue_diamond: HTTP & Persistence Methods

| Method Name      | Arguments       | Notes                                |
|------------------|-----------------|--------------------------------------|
| [`getLocations`](#getlocationsblock-failureblock) | `^successFn`, `^failureFn` | Fetch all the locations currently stored in native plugin's SQLite database. Your **`successFn`** will receive an **`NSArray`** of locations in the 1st parameter |
| [`getCount`](#int-getcount) | ` ` | Fetches count of SQLite locations table **`SELECT count(*) from locations`** |
| [`destroyLocations`](#destroylocations) |  | Delete all records in plugin's SQLite database |
| [`sync`](#syncblock-failureblock) | `^successFn`, `^failureFn` | If the plugin is configured for HTTP with an [`#url`](#config-nsstring-url--) and [`#autoSync: false`](#config-bool-autosync-yes), this method will initiate POSTing the locations currently stored in the native SQLite database to your configured [`#url`](#config-string-url--)|


### :small_blue_diamond: Geofencing Methods

| Method Name      | Arguments       | Notes                                |
|------------------|-----------------|--------------------------------------|
| [`startGeofences`](#startgeofences) |  | Engages the geofences-only **`trackingMode`**.  In this mode, no active location-tracking will occur -- only geofences will be monitored|
| [`addGeofence`](#addgeofencetsgeofence-successblock-failureblock) | `TSGeofence`, `^success`, `^failure` | Adds a geofence to be monitored by the native plugin.|
| [`addGeofences`](#addgeofencesnsarray-successblock-failureblock) | `[geofences]`, `sucessFn`, `failureFn` | Adds a list geofences to be monitored by the native plugin. |
| [`removeGeofence`](#removegeofencensstring-successblock-failureblock) | `identifier`, `successFn`, `failureFn` | Removes a geofence identified by the provided `identifier` |
| [`removeGeofences`](#removegeofences) | `successFn`, `failureFn` | Removes all geofences |
| [`getGeofences`](#nsarray-getgeofences) | `callbackFn` | Fetch the list of monitored geofences. |


### :small_blue_diamond: Logging Methods

| Method Name      | Arguments       | Notes                                |
|------------------|-----------------|--------------------------------------|
| [`getLog`](#getlogblock-failureblock) | `^callback` | Fetch the entire contents of the current log database as a `NSString`.|
| [`destroyLog`](#destroylog) | `^success`, `^failure` | Destroy the contents of the Log database. |
| [`emailLog`](#emaillognsstring-successblock-failureblock) | `email`, `^success`,`^failure` | Fetch the entire contents of Log database and email it to a recipient using the device's native email client.|
| [`playSound`](#playsoundsystemsoundidsoundid) | `SystemSoundID` | Here's a fun one.  The plugin can play a number of OS system sounds for each platform.  For [IOS](http://iphonedevwiki.net/index.php/AudioServices) and [Android](http://developer.android.com/reference/android/media/ToneGenerator.html).  I offer this API as-is, it's up to you to figure out how this works. |

# :wrench: Geolocation Options

#### `@config {CLLocationAccuracy} desiredAccuracy [kCLLocationAccuracyBest]`

Specify the desired-accuracy of the geolocation system.  See [Apple API docs](https://developer.apple.com/documentation/corelocation/cllocationaccuracy?language=objc) for available values.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.desiredAccuracy = kCLLocationAccuracyBest;
}];
```

:warning: Only **`kCLLocationAccuracyBest`** &amp; **`kCLLocationAccuracyBestForNavigation`** use GPS.  `speed`, `heading` and `altitude` are available only from GPS.


------------------------------------------------------------------------------

#### `@config {CLLocationDistance} distanceFilter [10]`

The minimum distance (measured in meters) a device must move horizontally before an update event is generated.

However, by default, **`distanceFilter`** is elastically auto-calculated by the plugin:  When speed increases, **`distanceFilter`** increases;  when speed decreases, so too does **`distanceFilter`**.  

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.distanceFilter = 50;
}];
```

:information_source: To disable this behaviour, configure [`disableElasticity: true`](#config-boolean-disableelasticity-false)

:information_source: To control the scale of the automatic `distanceFilter` calculation, see [`elasticityMultiplier`](#config-float-elasticitymultiplier-1)

**`distanceFilter`** is auto calculated by rounding speed to the nearest `5 m/s` and adding **`distanceFilter`** meters for each `5 m/s` increment.

For example, at biking speed of 7.7 m/s with a configured **`distanceFilter: 30`**:

```
  rounded_speed = round(7.7, 5)
  => 10
  multiplier = rounded_speed / 5
  => 10 / 5 = 2
  adjusted_distance_filter = multiplier * distanceFilter
  => 2 * 30 = 60 meters
```

At highway speed of `27 m/s` with a configured `distanceFilter: 50`:

```
  rounded_speed = round(27, 5)
  => 30
  multiplier = rounded_speed / 5
  => 30 / 5 = 6
  adjusted_distance_filter = multiplier * distanceFilter * elasticityMultipiler
  => 6 * 50 = 300 meters
```

Note the following real example of background-geolocation on highway 101 towards San Francisco as the driver slows down as he runs into slower traffic (geolocations become compressed as distanceFilter decreases)

![distanceFilter at highway speed](https://dl.dropboxusercontent.com/s/uu0hs0sediw26ar/distance-filter-highway.png?dl=1)

Compare now background-geolocation in the scope of a city.  In this image, the left-hand track is from a cab-ride, while the right-hand track is walking speed.

![distanceFilter at city scale](https://dl.dropboxusercontent.com/s/yx8uv2zsimlogsp/distance-filter-city.png?dl=1)

------------------------------------------------------------------------------

#### `@config {BOOL} disableElasticity [NO]`

Defaults to **`NO`**.  Set **`YES`** to disable automatic, speed-based [`#distanceFilter`](#config-cllocationdistance-distancefilter-10) elasticity.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.disableElasticity = YES;
}];
```

------------------------------------------------------------------------------

#### `@config {double} elasticityMultiplier [1]`

Controls the scale of automatic speed-based [`#distanceFilter`](#config-cllocationdistance-distancefilter-10) elasticity.  Increasing `elasticityMultiplier` will result in fewer location samples as speed increases.  A value of `0` has the same effect as [`disableElasticity: true`](#config-boolean-disableelasticity-false)

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.elasticityMultiplier = 2;
}];
```

------------------------------------------------------------------------------


#### `@config {CLLocationDistance} stationaryRadius [25]`

When stopped, the minimum distance the device must move beyond the stationary location for aggressive background-tracking to engage.

Configuring **`stationaryRadius: 0`** has **NO EFFECT** (in fact the plugin enforces a minimum **``stationaryRadius``** of `25`).

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stationaryRadius = 25;
}];
```

The following image shows the typical distance iOS requires to detect exit of the **`stationaryRadius`**, where the *green* polylines represent a transition from **stationary** state to **moving** and the *red circles* locations where the plugin entered the **stationary** state.:

![](https://dl.dropboxusercontent.com/s/vnio90swhs6xmqm/screenshot-ios-stationary-exit.png?dl=1)

:blue_book: For more information, see [Philosophy of Operation](../../../wiki/Philosophy-of-Operation)

:warning: iOS will not detect the exact moment the device moves out of the stationary-radius.  In normal conditions, it will typically take **~200 meters** before the plugin begins tracking.  

------------------------------------------------------------------------------


#### `@config {double} stopAfterElapsedMinutes [-1]`

The plugin can optionally automatically stop tracking after some number of minutes elapses after the `#start` method was called.

```obj-c
TSConfig *config = [TSConfig sharedInstance];

TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stopAfterElapsedMinutes = 30;
}];
.
.
.
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo ready];

[bgGeo start];  // <-- plugin will automatically #stop itself after 30 minutes

```

------------------------------------------------------------------------------

#### `@config {BOOL} stopOnStationary [NO]`

The plugin can optionally automatically stop tracking when the `stopTimeout` timer elapses.  For example, when the plugin first detects a `motionchange` into the "moving" state, the next time a `motionchange` event occurs into the "stationary" state, the plugin will have automatically called `#stop` upon itself.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stopOnStationary = YES;
}];
```

:warning: `stopOnStationary` will **only** occur due to `stopTimeout` timer elapse.  It will **not** occur by manually executing `changePace:NO`.

------------------------------------------------------------------------------

#### `@config {CLLocationAccuracy} desiredOdometerAccuracy [100]`

Specify an accuracy threshold in **meters** for odometer calculations.  Defaults to `100`.  If a location arrives having **`accuracy > desiredOdometerAccuracy`**, that location will not be used to update the odometer.  If you only want to calculate odometer from GPS locations, you could set **`desiredOdometerAccuracy: 10`**.  This will prevent odometer updates when a device is moving around indoors, in a shopping mall, for example.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.desiredOdometerAccuracy = 100;
}];
```

------------------------------------------------------------------------------


#### `@config {BOOL} useSignificantChangesOnly [NO]`

Defaults to `NO`.  Set `YES` in order to disable constant background-tracking and use only the iOS [Significant Changes API](https://developer.apple.com/reference/corelocation/cllocationmanager/1423531-startmonitoringsignificantlocati?language=objc).  

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.useSignificantChangesOnly = YES;
}];
```

:warning: If Apple has denied your application, refusing to grant your app the privelege of using the **`UIBackgroundMode: "location"`**, this can be a solution.  **NOTE** The Significant Changes API will report a location only every `500` to `1000` meters.  Many of the plugin's configuration parameters **will be ignored**, such as [`#distanceFilter`](#config-integer-distancefilter), [`#stationaryRadius`](#config-cllocationdistance-stationaryradius-meters), [`#activityType`](#config-clactivitytype-activitytype-clactivitytypeother), etc.

------------------------------------------------------------------------------

#### `@config {BOOL} pausesLocationUpdatesAutomatically [YES]`

:warning: This option should generally be left `undefined`.  You should only specifiy this option if you know *exactly* what you're doing.

The default behaviour of the plugin is to turn **off** location-services *automatically* when the device is detected to be stationary.  When set to `false`, location-services will **never** be turned off (and `disableStopDetection` will automatically be set to `true`) -- it's your responsibility to turn them off when you no longer need to track the device.  This feature should **not** generally be used.  `preventSuspend` will no longer work either.

------------------------------------------------------------------------------

#### `@config {NSString} locationAuthorizationRequest [Always]`

The desired iOS location-authorization request, either **`Always`**, **`WhenInUse`** or **`Any`**.  **`locationAuthorizationRequest`** tells the plugin the mode it *expects* to be in &mdash; if the user changes this mode in their settings, the plugin will detect this (@see [`locationAuthorizationAlert`](#config-nsdictionary-locationauthorizationalert)).  Defaults to **`Always`**.  **`WhenInUse`** will display a **blue bar** at top-of-screen informing user that location-services are on.

Configuring **`Any`** will tell the plugin to operate in whichever mode the user selects, eight `WhenInUse` or `Always`.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.locationAuthorizationRequest = @"Always";
}];
```

:warning: Configuring **`WhenInUse`** will disable many of the plugin's features, since iOS forbids any API which operates in the background to operate (such as **geofences**, which the plugin relies upon to automatically engage background tracking).

------------------------------------------------------------------------------

#### `@config {NSDictionary} locationAuthorizationAlert`

When you configure the plugin location-authorization `Always` or `WhenInUse` and the user changes the value in the app's location-services settings or disabled location-services, the plugin will display an Alert directing the user to the **Settings** screen.  This config allows you to configure all the Strings for that Alert popup and accepts an `{Object}` containing the following keys:

##### `@config {NSString} titleWhenOff [Location services are off]`  The title of the alert if user changes, for example, the location-request to `WhenInUse` when you requested `Always`.

##### `@config {NSString} titleWhenNotEnabled [Background location is not enabled]`  The title of the alert when user disables location-services or changes the authorization request to `Never`

##### `@config {NSString} instructions [To use background location, you must enable {locationAuthorizationRequest} in the Location Services settings]`  The body text of the alert.

##### `@config {NSString} cancelButton [Cancel]` Cancel button label

##### `@config {NSString} settingsButton [Settings]` Settings button label

![](s/wyoaf16buwsw7ed/docs-locationAuthorizationAlert.jpg?dl=1)

```obj-c
TSConfig *config = [TSConfig sharedInstance];

TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.locationAuthorizationAlert = @{
        @"titleWhenNotEnabled":@"Yo, location-services not enabled",
        @"titleWhenOff":@"Yo, location-services OFF",
        @"instructions":@"You must enable 'Always' in location-services, buddy",
        @"cancelButton":@"Cancel",
        @"settingsButton":@"Settings"  
    };
}];
```

------------------------------------------------------------------------------

# :wrench: Activity Recognition Options

#### `@config {double millis} [10000] activityRecognitionInterval`

Defaults to `10000` (10 seconds).  The desired time between activity detections. Larger values will result in fewer activity detections while improving battery life. A value of 0 will result in activity detections at the fastest possible rate.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.activityRecognitionInterval = 10000;
}];
```

------------------------------------------------------------------------------

#### `@config {NSInteger} minimumActivityRecognitionConfidence [75]` 

Each activity-recognition-result returned by the API is tagged with a "confidence" level expressed as a %.  You can set your desired confidence to trigger a [`motionchange`](#motionchange) event.  Defaults to **`75`**.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.minimumActivityRecognitionConfidence = 75;
}];
```

------------------------------------------------------------------------------

#### `@config {double} stopTimeout [5]`

When in the **moving** state, specifies the number of minutes to wait before turning off location-services and enter **stationary** state after the ActivityRecognition System detects the device is `STILL` (defaults to 5min).  If you don't set a value, the plugin is eager to turn off the GPS ASAP.  An example use-case for this configuration is to delay GPS OFF while in a car waiting at a traffic light.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stopTimeout = 5;
}];
```

:blue_book: See [Philosophy of Operation](../../../wiki/Philosophy-of-Operation)

:warning: Setting a value > 15 min is **not** recommended, particularly for Android.

------------------------------------------------------------------------------

#### `@config {BOOL} disableStopDetection [NO]`

Disables the accelerometer-based **Stop-detection System**.  When disabled, the plugin will use the default iOS behaviour of automatically turning off location-services when the device has stopped for exactly 15 minutes.  When disabled, you will no longer have control over [`#stopTimeout`](#config-integer-minutes-stoptimeout).

**iOS Stop-detection timing**.
![](https://dl.dropboxusercontent.com/s/ojjdfkmua15pskh/ios-stop-detection-timing.png?dl=1)

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.disableStopDetection = NO;
}];
```

## :wrench: [Activity Recognition] iOS Options


#### `@config {CLActivityType} activityType [CLActivityTypeOther]`

Presumably, this affects ios GPS algorithm.

:blue_book: [Apple docs](https://developer.apple.com/reference/corelocation/cllocationmanager/1620567-activitytype?language=objc).

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.activityType = CLActivityTypeOther;
}];
```

------------------------------------------------------------------------------

#### `@config {double} stopDetectionDelay [0]` 

Measured in **minutes**; defaults to **`0`**.  Allows the stop-detection system to be delayed from activating.  When the stop-detection system *is* engaged, location-services will be turned **off** and only the accelerometer is monitored.  Stop-detection will only engage if this timer expires.  The timer is cancelled if any movement is detected before expiration.  If a value of **`0`** is specified, the stop-detection system will engage as soon as the device is detected to be stationary.

**iOS Stop-detection timing**.
![](https://dl.dropboxusercontent.com/s/ojjdfkmua15pskh/ios-stop-detection-timing.png?dl=1)

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stopDetectionDelay = 1;
}];
```

------------------------------------------------------------------------------

#### `@config {BOOL} disableMotionActivityUpdates [NO]`

Defaults to **`NO`**.  Set **`YES`** to disable iOS [`CMMotionActivityManager`](https://developer.apple.com/reference/coremotion/cmmotionactivitymanager) updates (eg: `walking`, `in_vehicle`).  This feature requires a device having the **M7** co-processor (ie: iPhone 5s and up).

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.disableMotionActivityUpdates = NO;
}];
```

:information_source: This feature will ask the user for "Health updates" permission using the **[`MOTION_USAGE_DESCRIPTION`](https://github.com/transistorsoft/cordova-background-geolocation#configuring-the-plugin)**.  If you do not wish to ask the user for the "Health updates", set this option to `true`; However, you will no longer receive accurate activity data in the recorded locations.

:warning: The plugin is **HIGHLY** optimized for motion-activity-updates.  If you **do** disable this, the plugin *will* drain more battery power.  You are **STRONGLY** advised against disabling this.  You should explain to your users with the **[`MOTION_USAGE_DESCRIPTION`](https://github.com/transistorsoft/cordova-background-geolocation#configuring-the-plugin)**, for example:

> "Accelerometer use increases battery efficiency by intelligently toggling location-tracking"

# :wrench: Geofencing Options

#### `@config {CLLocationDistance} geofenceProximityRadius [1000]`

Defaults to `1000` meters.  **@see** releated event [`geofenceschange`](#geofenceschange).  When using Geofences, the plugin activates only thoses in proximity (the maximim geofences allowed to be simultaneously monitored is limited by the platform, where **iOS** allows only 20 and **Android**.  However, the plugin allows you to create as many geofences as you wish (thousands even).  It stores these in its database and uses spatial queries to determine which **20** or **100** geofences to activate.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.geofenceProximityRadius = 1000;
}];
```

:blue_book: [See Geofencing Guide](geofencing.md)

:tv: [View animation of this behaviour](https://dl.dropboxusercontent.com/u/2319755/background-geolocation/images/background-geolocation-infinite-geofencing.gif)

![](s/7sggka4vcbrokwt/geofenceProximityRadius_iphone6_spacegrey_portrait.png?dl=1)

------------------------------------------------------------------------------

#### `@config {BOOL} geofenceInitialTriggerEntry [YES]`

Defaults to `YES`.  Set `NO` to disable triggering a geofence immediately if device is already inside it.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.geofenceInitialTriggerEntry = YES;
}];
```

------------------------------------------------------------------------------


# :wrench: HTTP & Persistence Options


#### `@config {NSString} url [""]`

Your server **`url`** where you wish to HTTP POST location data to.

```obj-c
TSConfig *config [TSConfig sharedInstance];

[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.autoSync = YES;
    builder.params = @{@"foo":@"bar"};
    builder.headers = @{@"X-FOO":@"BAR"};
}];
```

:blue_book: See [HTTP Guide](http.md) for more information.

:warning: It is highly recommended to let the plugin manage uploading locations to your server, **particularly for Android** when configured with **`stopOnTerminate: NO`**, since your Cordova app (where your Javascript lives) *will* terminate &mdash; only the plugin's native Android background service will continue to operate, recording locations and uploading to your server.  The plugin's native HTTP service *is* better at this task than Javascript Ajax requests, since the plugin will automatically retry on server failure.

------------------------------------------------------------------------------

#### `@config {NSInteger} httpTimeout [60000]`

HTTP request timeout in **milliseconds**.  The `http` **`failureFn`** will execute when an HTTP timeout occurs.  Defaults to `60000 ms` (1 minute).

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

// Listen to http events
[bgGeo onHttp:^(TSHttpEvent *event) {
    NSLog(@"- http: %lu", event.statusCode);
}];

TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.httpTimeout = 3000;
}];
```

------------------------------------------------------------------------------

#### `@config {NSString} method [POST]`

The HTTP method to use when creating an HTTP request to your configured [`#url`](#config-string-url--).  Defaults to `POST`.  Valid values are `POST`, `PUT` and `OPTIONS`.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.method = @"PUT";
}];
```

------------------------------------------------------------------------------

#### `@config {NSDictionary} params`

Optional HTTP **`params`** sent along in each HTTP request.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.params = @{
        @"user_id":@(1234),
        @"device_id":@"abc123"
    };
}];
```

```javascript
POST /locations
 {
  "location": {
    "coords": {
      "latitude": 45.51927004945047,
      "longitude": -73.61650072045029
      .
      .
      .
    }
  },
  "user_id": 1234,
  "device_id": 'abc123'
}

```

------------------------------------------------------------------------------

#### `@config {NSDictionary} headers`

Optional HTTP params sent along in HTTP request to above [`#url`](#config-nsstring-url-).

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.headers = @{
        @"X-FOO":@"BAR",
        @"X-AUTH-TOKEN":@"23l4klaksjdflkjasdfkljaslk23j4lk2j34"
    };
}];
```

------------------------------------------------------------------------------

#### `@config {NSString} httpRootProperty [location]`

The root property of the JSON data where location-data will be placed.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.httpRootProperty = @"rootProperty";
}];
```

:blue_book: See [HTTP Guide](http.md) for more information.

```json
{
    "rootProperty":{
        "coords": {
            "latitude":23.232323,
            "longitude":37.373737
        }
    }
}
```

You may also specify the character **`httpRootProperty:"."`** to place your data in the *root* of the JSON:

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.httpRootProperty = @".";
}];
```

```json
{
    "coords": {
        "latitude":23.232323,
        "longitude":37.373737
    }
}
```

------------------------------------------------------------------------------

#### `@config {NSString} locationTemplate [undefined]`

Optional custom template for rendering `location` JSON request data in HTTP requests.  Evaulate variables in your **`locationTemplate`** using Ruby `erb`-style tags:

```erb
<%= variable_name %>
```

:blue_book: See [HTTP Guide](http.md) for more information.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.locationTemplate = @"{\"lat\":<%= latitude %>,\"lng\":<%= longitude %>,\"event\":\"<%= event %>\",isMoving:<%= isMoving %>}";
}];

// Or use a compact [Array] template
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.locationTemplate = @"[<%=latitude%>, <%=longitude%>, \"<%=event%>\", <%=is_moving%>]";
}];

```

:warning: If you've configured [`#extras`](#config-object-extras), these key-value pairs will be merged *directly* onto your location data.  Eg:

```obj-c
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.extras = @{@"foo":@"bar"};
    builder.httpRootProperty = @"data";
    builder.locationTemplate = @"{\"lat\":<%= latitude %>,\"lng\":<%= longitude %>}";
}];
```

Will result in JSON:
```json
{
    "data": {
        "lat":23.23232323,
        "lng":37.37373737,
        "foo":"bar"
    }
}
```

**Template Tags**

| Tag | Type | Description |
|-----|------|-------------|
| `latitude` | `Float` ||
| `longitude` | `Float` ||
| `speed` | `Float` | Meters|
| `heading` | `Float` | Degress|
| `accuracy` | `Float` | Meters|
| `altitude` | `Float` | Meters|
| `altitude_accuracy` | `Float` | Meters|
| `timestamp` | `String` |ISO-8601|
| `uuid` | `String` |Unique ID|
| `event` | `String` |`motionchange|geofence|heartbeat`
| `odometer` | `Float` | Meters|
| `activity.type` | `String` | `still|on_foot|running|on_bicycle|in_vehicle|unknown`|
| `activity.confidence` | `Integer` | 0-100%|
| `battery.level` | `Float` | 0-100%|
| `battery.is_charging` | `Boolean` | Is device plugged in?|

------------------------------------------------------------------------------

#### `@config {NSString} geofenceTemplate [undefined]`

Optional custom template for rendering `geofence` JSON request data in HTTP requests.  The `geofenceTemplate` is similar to [`#locationTemplate`](#config-string-locationtemplate-undefined) with the addition of two extra `geofence.*` tags.

Evaulate variables in your **`geofenceTemplate`** using Ruby `erb`-style tags:

```erb
<%= variable_name %>
```

:blue_book: See [HTTP Guide](http.md) for more information.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.geofenceTemplate = @"{\"lat\":<%= latitude %>,\"lng\":<%= longitude %>, \"geofence\":\"<%= geofence.identifier %>:<%= geofence.action %>\"}";
}];
```

**Template Tags**
The tag-list is identical to [`#locationTemplate`](#config-string-locationtemplate-undefined) with the addition of `geofence.identifier` and `geofence.action`.  

| Tag | Type | Description |
|-----|------|-------------|
| **`geofence.identifier`** | `String` | Which geofence?|
| **`geofence.action`** | `String` | `ENTER|EXIT`|
| `latitude` | `Float` ||
| `longitude` | `Float` ||
| `speed` | `Float` | Meters|
| `heading` | `Float` | Degress|
| `accuracy` | `Float` | Meters|
| `altitude` | `Float` | Meters|
| `altitude_accuracy` | `Float` | Meters|
| `timestamp` | `String` |ISO-8601|
| `uuid` | `String` |Unique ID|
| `event` | `String` |`motionchange|geofence|heartbeat`
| `odometer` | `Float` | Meters|
| `activity.type` | `String` | `still|on_foot|running|on_bicycle|in_vehicle|unknown`
| `activity.confidence` | `Integer` | 0-100%|
| `battery.level` | `Float` | 0-100%|
| `battery.is_charging` | `Boolean` | Is device plugged in?|

------------------------------------------------------------------------------

#### `@config {BOOL} batchSync [NO]`

Default is **`NO`**.  If you've enabled HTTP feature by configuring an [`#url`](#config-nsstring-url--), `batchSync = YES` will POST *all* the locations currently stored in native SQLite datbase to your server in a single HTTP POST request.  With [`batchSync: false`](#config-string-batchsync-false), an HTTP POST request will be initiated for **each** location in database.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.batchSync = YES;
}];
```

------------------------------------------------------------------------------

#### `@config {NSInteger} maxBatchSize [-1]`

If you've enabled HTTP feature by configuring an [`#url`](#config-nsstring-url--) with [`batchSync: true`](#config-bool-batchsync-no), this parameter will limit the number of records attached to **each** batch request.  If the current number of records exceeds the **`maxBatchSize`**, multiple HTTP requests will be generated until the location queue is empty.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.batchSync = YES;
    builder.maxBatchSize = 100;
}];
```

------------------------------------------------------------------------------

#### `@config {BOOL} autoSync [YES]`

Default is `YES`.  If you've enabeld HTTP feature by configuring an [`#url`](#config-string-url-undefined), the plugin will attempt to HTTP POST each location to your server **as it is recorded**.  If you set [`autoSync: NO`](#config-string-autosync-true), it's up to you to **manually** execute the [`#sync`](synccallbackfn-failurefn) method to initate the HTTP POST (**NOTE** The plugin will continue to persist **every** recorded location in the SQLite database until you execute [`#sync`](synccallbackfn-failurefn)).

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.autoSync = YES;
}];
```

------------------------------------------------------------------------------

#### `@config {NSInteger} autoSyncThreshold [0]`

The minimum number of persisted records to trigger an [`autoSync`](#config-string-autosync-true) action.  If you configure a value greater-than **`0`**, the plugin will wait until that many locations are recorded before executing HTTP requests to your server through your configured [`#url`](#config-string-url-undefined).

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.autoSyncThreshold = 0;
}];
```

------------------------------------------------------------------------------

#### `@config {NSDictionary} extras`

Optional arbitrary key/value `{}` to attach to each recorded location

Eg: Every recorded location will have the following **`extras`** appended:

:blue_book: See [HTTP Guide](http.md) for more information.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.url = @"http://my-server.com/locations";
    builder.extras = @{@"route_id":@(1234)};
    builder.params = @{@"device_id":@"abc123"};
}];
```

```javascript
- POST /locations
{
  "device_id": "abc123" // <-- params appended to root of JSON
  "location": {
    "coords": {
      "latitude": 45.51927004945047,
      "longitude": -73.61650072045029,
      .
      .
      .
    },
    "extras": {  // <-- extras appended to *each* location
      "route_id": 1234
    }
  }
}

```

------------------------------------------------------------------------------

#### `@config {NSInteger} maxDaysToPersist [1]`

Maximum number of days to store a geolocation in plugin's SQLite database when your server fails to respond with **`HTTP 200 OK`**.  The plugin will continue attempting to sync with your server until **`maxDaysToPersist`** when it will give up and remove the location from the database.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.maxDaysToPersist = 1;
}];
```

------------------------------------------------------------------------------

#### `@config {NSInteger} maxRecordsToPersist [-1]`

Maximum number of records to persist in plugin's SQLite database.  Default `-1`
 means **no limit**.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.maxRecordsToPersist = 1000;
}];
```

------------------------------------------------------------------------------

#### `@config {NSString} locationsOrderDirection [ASC]`

Controls the order that locations are selected from the database (and synced to your server).  Defaults to ascending (`ASC`), where oldest locations are synced first.  Descending (`DESC`) syncs latest locations first.|

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.locationsOrderDirection = @"ASC";
}];
```

------------------------------------------------------------------------------


# :wrench: Application Options

#### `@config {BOOL} stopOnTerminate [YES]`

Defaults to **`YES`**.  When the user terminates the app, the plugin will **stop** tracking.  Set this to **`NO`** to continue tracking after application terminate.

If you *do* configure **`stopOnTerminate: NO`**, your Javascript application **will** terminate at that time.  However, both Android and iOS differ in their behaviour *after* this point:

Before an iOS app terminates, the plugin will ensure that a **stationary geofence** is created around the last known position.  When the user moves beyond the stationary geofence (typically ~200 meters), iOS will completely reboot your application in the background, including your Javascript application and the plugin will resume tracking.  iOS maintains geofence monitoring at the OS level, in spite of application terminate / device reboot.

In the following image, imagine the user terminated the application at the **"red circle"** on the right then continued moving:  Once the device moves by about 200 meters, exiting the "stationary geofence", iOS reboots the app and tracking resumes.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.stopOnTerminate = NO;
}];
```

:information_source: [Demo Video of `stopOnTerminate: NO`](https://www.youtube.com/watch?v=aR6r8qV1TI8&t=214s)

![](https://dl.dropboxusercontent.com/s/1uip231l3gds68z/screenshot-stopOnTerminate-ios.png?dl=0)

------------------------------------------------------------------------------

#### `@config {BOOL} startOnBoot [NO]`

Defaults to **`NO`**.  Set **`YES`** to engage background-tracking after the device reboots.

iOS cannot **immediately** engage tracking after a device reboot.  Just like [`stopOnTerminate:NO`](#config-bool-stoponterminate-yes), iOS will not re-boot your app until the device moves beyond the **stationary geofence** around the last known location.  In addition, iOS subscribes to "background-fetch" events, which typically fire about every 15 minutes &mdash; these too are capable of rebooting your app after a device reboot.

```obj-c 
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.startOnBoot = YES;
}];
```

------------------------------------------------------------------------------


#### `@config {NSTimeInterval} heartbeatInterval [60]`

Controls the rate (in seconds) the [`heartbeat`](#heartbeat) event will fire.  The plugin will **not** provide any updated locations to your **`callbackFn`**, since it will provide only the last-known location.  If you wish for an updated location in your **`callbackFn`**, it's up to you to request one with [`#getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest).

:warning: On **iOS** the **`heartbeat`** event will fire only when configured with [`preventSuspend: YES`](#config-bool-preventsuspend-no)

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.heartbeatInterval = 60;    
}];

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo onHeartbeat:^(TSHeartbeatEvent *event) {
    NSLog(@"[heartbeat: %@", event);

    // You could request the current position if you wish:
    TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        NSLog(@"- currentPosition: %@", [location toDictionary]);
    } failure:^(NSError *error) {
        NSLog(@"- currentPosition error: %@", error);
    }];
    request.persist = YES;
    request.extras = @{@"foo":@"bar"};
    request.samples = 1;

    [bgGeo getCurrentPosition:request];
}];


```

------------------------------------------------------------------------------

#### `@config {NSArray} schedule []`

Provides an automated schedule for the plugin to start/stop tracking at pre-defined times.  The format is cron-like:

```obj-c
  @"{DAY(s)} {START_TIME}-{END_TIME}"
```

The `START_TIME`, `END_TIME` are in **24h format**.  The `DAY` param corresponds to the `Locale.US`, such that **Sunday=1**; **Saturday=7**).  You may configure a single day (eg: `1`), a comma-separated list-of-days (eg: `2,4,6`) or a range (eg: `2-6`), eg:

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.schedule = @[
        @"1 17:30-21:00",     // Sunday: 5:30pm-9:00pm
        @"2-6 9:00-17:00",    // Mon-Fri: 9:00am to 5:00pm
        @"2,4,6 20:00-00:00", // Mon, Web, Fri: 8pm to midnight (next day)
        @"7 10:00-19:00"      // Sat: 10am-7pm
    ];
}];

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

// Listen to schedule event
[bgGeo onSchedule:^(TSScheduleEvent *event) {
    TSConfig *config = [TSConfig sharedInstance];
    NSLog(@"[schedule] Tracking is enabled? %d", config.enabled);
}];

[bgGeo ready];

if (!config.schedulerEnabled) {
    [bgGeo startSchedule];
}

.
.
.
// Later when you want to stop the Scheduler (eg: user logout)
[bgGeo stopSchedule];

// Note:  if plugin is currently tracking, stopSchedule does not stop tracking.
if (config.enabled) {
    [bgGeo stop];
}
```

##### Literal Dates

The schedule can also be configured with a literal start date of the form:

```
  "yyyy-mm-dd HH:mm-HH:mm"
```

eg:

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.schedule = @[
        @"2018-01-01 09:00-17:00"
    ];
}];
```

Or **two** literal dates to specify both a start **and** stop date (note the format here is a bit ugly):

```
  @"yyyy-mm-dd-HH:mm yyyy-mm-dd-HH:mm"
```

```
  @"2018-01-01-09:00 2019-01-01-17:00"  // <-- track for 1 year
```

iOS **cannot** evaluate the Schedule at the *exact* time you configure &mdash; it can only evaluate the **`schedule`** *periodically*, whenever your app comes alive.  When the app is running in a scheduled **off** period, iOS will continue to monitor the low-power, [significant location changes API (SLC)](https://developer.apple.com/reference/corelocation/cllocationmanager/1423531-startmonitoringsignificantlocati?language=objc) in order to ensure periodic schedule evaluation.  **SLC** is required in order guarantee periodic schedule-evaluation when you're configured [`stopOnTerminate: YES`](#config-bool-stoponterminate-yes), since the [iOS Background Fetch]() is halted if user *manually* terminates the app.  **SLC** will awaken your app whenever a "significant location change" occurs, typically every `1000` meters.  If the schedule is currently in an **off** period, this location will **not** be persisted nor will it be sent to the [`location`](#location) event &mdash; only the **`schedule`** will be evaluated.

When a **`schedule`** is provided on iOS, it will be evaluated in the following cases:

- Application `pause` / `resume` events.
- Whenever a location is recorded (including **SLC**)
- Background fetch event

------------------------------------------------------------------------------


#### `@config {BOOL} preventSuspend [NO]`

Defaults to **`NO`**.  Set **`YES`** to prevent **iOS** from suspending after location-services have been switched off while your application is in the background.  Must be used in conjunction with a [`heartbeatInterval`](#config-nstimeinterval-heartbeatinterval-60).

:warning: **`preventSuspend: true`** should **only** be used in **very** specific use-cases and should typically **not** be used as it *will* have a **very noticable impact on battery performance.**  You should carefully manage **`preventSuspend`**, engaging it for controlled periods-of-time.  You should **not** expect to run your app in this mode 24 hours / day, 7 days-a-week.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.preventSuspend = YES;
}];

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
// iOS heartbeat event only works with preventSuspend: YES
[bgGeo onHeartbeat:^(TSHeartbeatEvent *event) {
    NSLog(@"[heartbeat]");
}];
```


------------------------------------------------------------------------------


# :wrench: Logging & Debug Options

:blue_book: [Logging & Debugging Guide](../../../wiki/Debugging)

#### `@config {BOOL} debug [NO]`

Defaults to **`NO`**.  When set to **`YES`**, the plugin will emit debugging sounds and notifications for life-cycle events of background-geolocation!

In you wish to hear debug sounds in the background, you must manually enable the **[x] Audio and Airplay** background mode in *Background Capabilities* of XCode.

![](https://dl.dropboxusercontent.com/s/iplaxheoq63oul6/Screenshot%202017-02-20%2012.10.57.png?dl=1)

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.debug = YES;
}];
```

:blue_book: See [Debugging Sounds](../../../wiki/Debug-Sounds)

------------------------------------------------------------------------------

#### `@config {TSLogLevel} logLevel [tsLogLevelOff]`

BackgroundGeolocation contains powerful logging features.  By default, the plugin boots with a value of **`LOG_LEVEL_VERBOSE`**, storing **3 days** worth of logs (configurable with [`logMaxDays`](#config-nsinteger-logmaxdays-3)) in its SQLite database.

The following log-levels are defined as **constants** on the `BackgroundGeolocation` object:

| logLevel            | Description                                      |
|---------------------|--------------------------------------------------|
|`tsLogLevelOff`      | Logging disabled                                 |
|`tsLogLevelError`    | Only log errors                                  |
|`tsLogLevelWarning`  | Only log warnings &amp; errors                   |
|`tsLogLevelInfo`     | Log Info, Warnings &amp; errors                  |
|`tsLogLevelDebug`    | Log debug, info, warnings &amp; errors           |
|`tsLogLevelVerbose`  | Log everything                                   |

Eg:
```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.logLevel = tsLogLevelWarning;
}];
```

:information_source: To retrieve the plugin's logs, see [`getLog`](#getlogblock-failureblock) & [`emailLog`](#emaillognsstring-successblock-failureblock).

:warning: When submitting your app to production, take care to configure the **`logLevel`** appropriately (eg: **`tsLogLevelError`**)

------------------------------------------------------------------------------


#### `@config {NSInteger} logMaxDays [3]`

Maximum number of days to persist a log-entry in database.  Defaults to **`3`** days.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.logMaxDays = 3;
}];
```

------------------------------------------------------------------------------

# :zap: Events

### `location`

Your **`^success`** block will be executed with the following signature whenever a new location is recorded:

#### `^success` Paramters

##### [`@param {TSLocation} location`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSLocation.h) The Location data (@see Wiki for [Location Data Schema](../../../wiki/Location-Data-Schema))

:information_source: When performing a `motionchange` or [`getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest), the plugin requests **multiple** location *samples* in order to record the most accurate location possible.  These *samples* are **not** persisted to the database but they will be provided to your `location` listener, for your convenience, since it can take some seconds for the best possible location to arrive.  For example, you might use these samples to progressively update the user's position on a map.  You can detect these *samples* in your `callbackFn` via `location.sample === true`.  If you're manually `POST`ing location to your server, you should ignore these locations.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onLocation:^(TSLocation *tsLocation) {
    CLLocation *location = tsLocation.location;
    NSLog(@"[location]: %@", [location toDictionary]);
} failure:^(NSError *error) {
    NSLog(@"[location] error: %@", error);
}];
```

#### `^failure` Paramters

##### `@param {NSError} error`

| Code  | Error                       |
|-------|-----------------------------|
| 0     | Location unknown            |
| 1     | Location permission denied  |
| 2     | Network error               |
| 408   | Location timeout            |

------------------------------------------------------------------------------

### `motionchange`

Your **`^callback`** block will be executed each time the device has changed-state between **MOVING** or **STATIONARY**.  The **`callbackFn`** will be provided with the following parameters:

##### [`@param {TSLocation} location`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSLocation.h)

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onMotionChange:^(TSLocation *tsLocation) {
    BOOL isMoving = tsLocation.isMoving;
    if (isMoving) {
        NSLog(@"[motionchange: Device has just started MOVING.  Tracking initiated");
    } else {
        NSLog(@"[motionchange: Device has stopped.  Tracking halted");
    }
}];
```

------------------------------------------------------------------------------


### `activitychange`

Your **`^callback`** will be executed each time the activity-recognition system receives an event (`still, on_foot, in_vehicle, on_bicycle, running`).  

It will be provided a [`TSActivityChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSActivityChangeEvent.h) containing the following parameters:

#### [`TSActivityChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSActivityChangeEvent.h)

##### `@param {NSString} activity [still|on_foot|running|on_bicycle|in_vehicle]`
##### `@param {NSInteger} confidence [0-100%]`

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onActivityChange:^(TSActivityChangeEvent *event) {
      NSString *activity = event.activity;
      NSInteger confidence = event.confidence;
      NSLog(@"[activitychange]: %@:%lu", activity, confidence);
}];
```

------------------------------------------------------------------------------


### `providerchange`

Your **`^callback`** fill be executed when a change in the state of the device's **Location Services** has been detected.  eg: "GPS ON", "Wifi only".  Your **`callbackFn`** will be provided with an **[`TSProviderChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSProviderChangeEvent.h)** containing the following properties

#### [`TSProviderChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSProviderChangeEvent.h) Paramters

##### `@param {BOOL} enabled` Whether location-services is enabled
##### `@param {BOOL} gps` Whether gps is enabled
##### `@param {BOOL} network` Whether wifi geolocation is enabled.
##### `@param {CLAuthorizationStatus} status` Location authorization status.

| Name                                        | Value |
|---------------------------------------------|-------|
| `kCLAuthorizationStatusNotDetermined`       | `0`   |
| `kCLAuthorizationStatusRestricted`          | `1`   |
| `kCLAuthorizationStatusDenied`              | `2`   |
| `kCLAuthorizationStatusAuthorizedAlways`    | `3`   |
| `kCLAuthorizationStatusAuthorizedWhenInUse` | `4`   |

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onProviderChange:^(TSProviderChangeEvent *event) {
    BOOL enabled  = event.enabled;
    BOOL gps      = event.gps;
    BOOL network  = event.network;
    CLAuthorizationStatus status = event.status;
    
    NSLog(@"[providerchange] enabled: %d, gps: %d, network: %d, status: %d", enabled, gps, network, status);
}];
```

------------------------------------------------------------------------------


### `geofence`

Adds a geofence event-listener.  Your supplied **`^callback`** will be called when any monitored geofence crossing occurs, provided with a [`TSGeofenceEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSGeofenceEvent.h) parameter.

#### [`TSGeofenceEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSGeofenceEvent.h) Paramters

##### `@param {NSString} action` The geofence transition action [ENTER|EXIT|DWELL]
##### `@param {TSLocation} location` The location where the geofence transition occurred.
##### `@param {TSGeofence} geofence` The geofence which caused the event

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onGeofence:^(TSGeofenceEvent *event) {
    NSString *action = event.action;
    TSLocation *tsLocation = event.location;
    CLLocation *location = tsLocation.location;
    TSGeofence *geofence = event.geofence;
    NSString *identifier = geofence.identifier;

    NSLog(@"[geofence] %@, %@, %@", identifier, [geofence toDictionary], [tsLocation toDictionary]);
}];
```

------------------------------------------------------------------------------


### `geofenceschange`

Fired when the list of monitored-geofences changed.  The Background Geolocation contains powerful geofencing features that allow you to monitor any number of circular geofences you wish (thousands even), in spite of limits imposed by the native platform APIs (**20 for iOS; 100 for Android**).

The plugin achieves this by storing your geofences in its database, using a [geospatial query](https://en.wikipedia.org/wiki/Spatial_query) to determine those geofences in proximity (@see config [geofenceProximityRadius](#config-cllocationdistance-geofenceproximityradius-1000)), activating only those geofences closest to the device's current location (according to limit imposed by the corresponding platform).

When the device is determined to be moving, the plugin periodically queries for geofences in proximity (eg. every minute) using the latest recorded location.  This geospatial query is **very fast**, even with tens-of-thousands geofences in the database.

It's when this list of monitored geofences *changes*, the plugin will fire the **`geofenceschange`** event.

:blue_book: For more information, see [Geofencing Guide](./geofencing.md)

#### [`TSGeofencesChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSGeofencesChangeEvent.h)

##### `@property {NSArray} on` The list of geofences just activated.
##### `@property {NSArray} off` The list of geofences just de-activated

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onGeofencesChange:^(TSGeofencesChangeEvent *event) {
    NSArray *geofencesOn    = event.on;
    NSArray *geofencesOff   = event.off;

    NSLog(@"- geofences that STARTED monitoring: %@", geofencesOn);
    NSLog(@"- geofences that STOPPED monitoring: %@", geofencesOff);
}];
```

This **`TSGeofencesChangeEvent`** provides only the *changed* geofences, those which just activated or de-activated.

When **all** geofences have been removed, the event object will provide an empty `NSArray` for both **`#on`** and **`#off`** properties, ie:

------------------------------------------------------------------------------


### `http`

The **`^callback`** will be executed for each successful HTTP request where the response-code is one of `200`, `201` or `204`.  **`failureFn`** will be executed for all other HTTP response codes.  The **`successFn`** and **`failureFn`** will be provided a single **`response {Object}`** parameter with the following properties:

#### [`TSHttpEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSHttpEvent.h)

##### `@property {NSInteger} statusCode`.  The HTTP status code
##### `@property {NSString} responseText` The HTTP response as String.

Example:

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onHttp:^(TSHttpEvent *event) {
    NSInteger status = event.statusCode;
    NSString *responseText = event.responseText;
    
    NSLog(@"[http] %ld, %@", status, responseText);
}];
```

------------------------------------------------------------------------------


### `heartbeat`

The **`^callback`** will be executed for each [`#heartbeatInterval`](#config-nstimeinterval-heartbeatinterval-60) while the device is in **stationary** state (**iOS** requires [`preventSuspend: true`](#config-bool-preventsuspend-no) as well).  The **`^callback`** will be provided a `TSHeartbeatEvent` parameter:

#### [`TSHeartbeatEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSHeartbeatEvent.h)

##### [`@property {TSLocation} location`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSLocation.h)  Last known location.  **Note** The heartbeat event does not request a new location.  If you to have a new location, use [`#getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest) in your `^callback` block.

Example:

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onHeartbeat:^(TSHeartbeatEvent *event) {
    TSLocation *tsLocation = event.location;
    CLLocation *location = tsLocation.location;
    NSLog(@"[heartbeat] %@", [tsLocation toDictionary]);
}];
```

------------------------------------------------------------------------------


### `schedule`

The **`^callback`** will be executed each time a [`schedule`](#schedule) event fires.  Your **`^callback`** will be provided with `TSScheduleEvent` parameter.  Query the `#enabled` property of `TSConfig` to determine if the schedule enabled or disabled tracking.

#### [`TSScheduleEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSScheduleEvent.h)

##### [`@property {TSSchedule} schedule`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSSchedule.h) The scedule item which fired.

```objc
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo onSchedule:^(TSScheduleEvent *event) {
    TSConfig *config = [TSConfig sharedInstance];
    BOOL enabled = config.enabled;
    NSLog(@"[schedule] Tracking is enabled? %d", enabled);
}];
```

------------------------------------------------------------------------------


### `powersavechange`

Fired when the state of the operating-system's "Power Saving" mode changes.  Your `^callback` will be provided with a [`TSPowerSaveChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSPowerSaveChangeEvent.h) parameter signalling whether "Power Saving" is **enabled** or **disabled**.  Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.

:information_source: You can manually request the current-state of "Power Saving" mode with the **method** [`#isPowerSaveMode`](#ispowersavemodecallbackfn).

iOS Power Saving mode can be engaged manually by the user in **Settings -> Battery** or from an automatic OS dialog.

![](https://dl.dropboxusercontent.com/s/lz3zl2jg4nzstg3/Screenshot%202017-09-19%2010.34.21.png?dl=1)

#### [`TSPowerSaveChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSPowerSaveChangeEvent.h)

##### `@property {BOOL} isPowerSaveMode`

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onPowerSaveChange:^(TSPowerSaveChangeEvent *event) {
    NSLog(@"[powersavechange] is power save mode enabled? %d", event.isPowerSaveMode);
}];
```

------------------------------------------------------------------------------


### `connectivitychange`

Fired when the state of the device's network-connectivity changes (enabled -> disabled and vice-versa).  By default, the plugin will automatically fire a `connectivitychange` event with the current state network-connectivity whenever the **`#start`** method is executed.  Your `^callback` will be provided a [`TSConnectivityChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSConnectivityChangeEvent.h) parameter:

#### [`TSConnectivityChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSConnectivityChangeEvent.h)

##### `@property {BOOL} hasConnection`

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onConnectivityChange:^(TSConnectivityChangeEvent *event) {
    NSLog(@"[connectivitychange] has network connection? %d", event.hasConnection);
}];
```

------------------------------------------------------------------------------


### `enabledchange`

Fired when the plugin's **`enabled`** state changes.  For example, executing `#start` and `#stop` will cause the `enabledchange` event to fire.  This event is primarily desigend for use with the configuration option **[`stopAfterElapsedMinutes`]**, which automatically executes the plugin's `#stop` method.  Your `^callback` will be provided a [`TSEnabledChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSEnabledChangeEvent.h) parameter:

#### [`TSEnabledChangeEvent`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSEnabledChangeEvent.h)

##### `@property {BOOL} enabled` `YES` when the plugin has been enabled.  `NO` otherwise.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo onConnectivityChange:^(TSConnectivityChangeEvent *event) {
    NSLog(@"[connectivitychange] tracking is enabled? %d", event.enabled);
}];
```

------------------------------------------------------------------------------


# :large_blue_diamond: Methods

## :small_blue_diamond: Core API Methods

### `ready`

The **`#ready`** method is your first point-of-contact with the SDK.  You must execute the `#ready` method each time your application boots.

:information_source: BackgroundGeolocation persists its **`enabled`** state between application terminate or device reboot and **`#ready`** will **automatically** [`#start`](startsuccessfn-failurefn) tracking if it finds **`enabled == true`**.  

------------------------------------------------------------------------------


### `start`

Enable location tracking.  This is the SDK's power **ON** button.  The SDK will initially start into its **stationary** state, fetching an initial location before turning off location services and firing the `motionchange` event.

```obj-c

- (IBAction)onClickStart:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    [bgGeo start];
}
```

**Note:** The plugin persists its enabled state between restarts / reboots and will automatically `#start` itself after executing the `#ready` method.

```obj-c
@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    TSConfig *config = [TSConfig sharedInstance];
    
    if (!config.isFirstBoot) {
      [config updateWithBlock:^(TSConfigBuilder *builder) {
          builder.distanceFilter = 10;
          builder.debug = YES;
          builder.desiredAccuracy = kCLLocationAccuracyBest;          
          builder.logLevel = tsLogLevelVerbose;
          builder.stopOnTerminate = NO;
          builder.startOnBoot = YES;
      }];
    }

    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    
    // If the SDK is current enabled, #ready will automatically execute #start
    [bgGeo ready];
}
```

:blue_book: For more information, see [Philosophy of Operation](../../../wiki/Philosophy-of-Operation)

------------------------------------------------------------------------------


### `stop`

Disable location tracking.  This is the SDK's power **OFF** button.

```obj-c
- (IBAction)onClickStop:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

    [bgGeo stop];
}

```

:warning: If you've configured a [`schedule`](config-array-schedule-undefined), **`#stop`** will **not** halt the Scheduler.  You must explicitly stop the Scheduler as well:

```javascript
// Later when you want to stop the Scheduler (eg: user logout)
BackgroundGeolocation.stopSchedule(function() {
  console.info('- Scheduler stopped');
  // You must explicitly stop tracking if currently enabled
  BackgroundGeolocation.stop();
});
```

------------------------------------------------------------------------------


### `getCurrentPosition:(TSCurrentPositionRequest*)`

Retrieves the current position.  This method instructs the native code to fetch exactly one location using maximum power & accuracy.  The native code will persist the fetched location to its SQLite database just as any other location in addition to POSTing to your configured [`#url`](#config-string-url-undefined) (if you've enabled the HTTP features).

If a location is successfully retrieved, the `^success` block will be provided a `TSLocation` parameter.

If an error occurs while fetching the location, the **`^failure`** will be executed with an **`NSInteger`** [Error Code](../../../wiki/Location-Error-Codes) as the first argument.

#### `TSCurrentPositionRequest`

##### `@property {NSTimeInterval} timeout [30]` An optional location-timeout.  If the timeout expires before a location is retrieved, the `failure` callback will be executed.

##### `@property {double millis} maximumAge [0]` Accept the last-recorded-location if no older than supplied value in milliseconds.

##### `@property {BOOL} persist [YES]` Defaults to `YES`.  Set `NO` to disable persisting the retrieved location in the plugin's SQLite database.

##### `@property {NSInteger} samples [3]` Sets the maximum number of location-samples to fetch.  The plugin will return the location having the best accuracy to your `successFn`.  Defaults to `3`.  Only the final location will be persisted.

##### `@property {CLLocationAccuracy} desiredAccuracy [stationaryRadius]` Sets the desired accuracy of location you're attempting to fetch.  When a location having `accuracy <= desiredAccuracy` is retrieved, the plugin will stop sampling and immediately return that location.  Defaults to your configured `stationaryRadius`.

##### `@property {NSDicationary} extras` Optional extra-data to attach to the location.  These `extras {Object}` will be merged to the recorded `location` and persisted / POSTed to your server (if you've configured the HTTP Layer).

##### [`@property {^(TSLocation*)} success`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSLocation.h) Block to receive location.

##### `@property {^(NSError*)} failure` Block to receive error.

```obj-c
// Create Requst
TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
    NSLog(@"- getCurrentPosition success: %@", [location toDictionary]);
} failure:^(NSError *error) {
    NSLog(@"- getCurrentPosition failure: %@", error);
}];
request.maximumAge = 0;
request.persist = YES;
request.samples = 3;
request.desiredAccuracy = 0;
request.extras = @{@"foo":@"bar"};

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
// Execute Request
[bgGeo getCurrentPosition:request];
```

:information_source: While the **`success`** block will receive only **one** location, the plugin *does* request **multiple** location [`samples`](#config-integer-samples-3-sets-the-maximum-number-of-location-samples-to-fetch--the-plugin-will-return-the-location-having-the-best-accuracy-to-your-successfn--defaults-to-3--only-the-final-location-will-be-persisted) in order to record the most accurate location possible.  These *samples* are **not** persisted to the database but they will be provided to your [`location`](#location) event-listener, for your convenience, since it can take some seconds for the best possible location to arrive.  For example, you might use these samples to progressively update the user's position on a map.  You can detect these *samples* in your [`location`](#location) `success` block via `location.sample`.  If you're manually `POST`ing location to your server, you should ignore these locations.

If a location failed to be retrieved, the `^failure` block will be executed and provided with an `NSError` with one of the following error-codes:

| Code  | Error                       |
|-------|-----------------------------|
| 0     | Location unknown            |
| 1     | Location permission denied  |
| 2     | Network error               |
| 408   | Location timeout            |


------------------------------------------------------------------------------


### `watchPosition:(TSWatchPositionRequest*)`

Start a stream of continuous location-updates.  The native code will persist the fetched location to its SQLite database just as any other location in addition to POSTing to your configured [`#url`](#config-string-url-undefined) (if you've enabled the HTTP features).

:warning: **`#watchPosition`** is **not** reccommended for **long term** monitoring in the background &mdash; It's primarily designed for use in the foreground **only**.  You might use it for fast-updates of the user's current position on the map, for example.

**`#watchPosition`** will continue to run in the background, preventing iOS from suspending your application.  Take care to listen to `suspend` event and call [`#stopWatchPosition`](stopwatchpositionsuccessfn-failurefn) if you don't want your app to keep running (TODO make this configurable).


#### `TSWatchPositionRequest`

##### `@property {double millis} interval [1000]` Location update interval
##### `@property {CLLocationAccuracy} desiredAccuracy [0]`
##### `@property {BOOL} persist [YES]` Whether to persist location to database
##### `@property {NSDictionary} extras [undefined]` Optional extras to append to each location
##### [`@property {^(TSLocation*)}`](../ios/BackgroundGeolocation/Frameworks/TSLocationManager.framework/Headers/TSLocation.h) Callback to receive locations
##### `@property {^(NSError*)}` Callback to receive errors.

```obj-c
TSWatchPositionRequest *request = [[TSWatchPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
    NSLog(@"- watchPosition success: %@", [location toDictionary]);
} failure:^(NSError *error) {
    NSLog(@"- watchPosition failure: %@", error);        
}];

request.interval = 5000;
request.persist = YES;
request.extras = @{@"foo":@"bar"};
request.timeout = 60000;
```

:information_source: Also see [`#stopWatchPosition`](stopwatchposition)

------------------------------------------------------------------------------


### `stopWatchPosition`

Halt [`#watchPosition`](watchpositiontswatchpositionrequest) updates.

```obj-c
[[TSLocationManager sharedInstance] stopWatchPosition];
```

------------------------------------------------------------------------------


### `changePace:(BOOL)`

Manually Toggles the plugin **motion state** between **stationary** and **moving**.  When **`enabled`** is set to **`YES`**, the plugin will engage location-services and begin aggressively tracking the device's location *immediately*, bypassing stationary monitoring.  If you were making a "Jogging" application, this would be your **[Start Workout]** button to immediately begin location-tracking.  Send **`NO`** to turn **off** location-services and return the plugin to the **stationary** state.

Executing `#changePace` will cause the [`motionchange`](#motionchange) event to fired.

```obj-c
- (IBAction)onClickChangePace:(UIBarButtonItem*)sender {
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    TSConfig *config = [TSConfig sharedInstance];    
    if (!config.enabled) { return; }

    [bgGeo changePace:!config.isMoving];    
}
```

------------------------------------------------------------------------------

### `(CLLocationDistance) getOdometer`

Retrieves the current value of the odometer in meters.  The value of the odometer is persisted between application boots / device restarts.  **Note**: `odometer` is available from `TSConfig` -- not `TSLocationManager`.

```obj-c
TSConfig *config = [TSConfig sharedInstance];
CLLocationDistance odometer = config.odometer;
```

------------------------------------------------------------------------------


### `setOdometer:(CLLocationDistance) request:(TSCurrentPositionRequest*)`

Set the **`odometer`** to *any* arbitrary value.  **NOTE** `setOdometer` will perform a [`getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest) in order to record to exact location where odometer was set; as a result, the `callback` signatures are identical to those of [`getCurrentPosition`](#getcurrentpositiontscurrentpositionrequest).

```obj-c
TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
    NSLog(@"- setOdometer success: %@", [location toDictionary])
} failure:^(NSError *error) {
    NSLog(@"- setOdometer failure: %@", error);
}];

[[TSLocationManager sharedInstance] setOdometer:0 request:request];
```

------------------------------------------------------------------------------

### `startSchedule`

If a [`#schedule`](#config-array-schedule-undefined) was configured, this method will initiate that schedule.  The plugin will automatically be started or stopped according to the configured [`#schedule`](#config-array-schedule-undefined).

```javascript
TSConfig *config = [TSConfig sharedInstance];
[config updateWithBlock:^(TSConfigBuilder *builder) {
    builder.schedule = @[
      '1-7 09:00-17:00',
      '1 19:00-23:00'
    ];
}];

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

// Listen to schedule event
[bgGeo onSchedule:^(TSScheduleEvent *event) {
    NSLog(@"- Schedule event fired");
}];

// Start the scheduler
[bgGeo startSchedule];
.
.
.
// Stop the scheduler
[bgGeo stopSchedule];
```

------------------------------------------------------------------------------


### `stopSchedule`

This method will stop the Scheduler service.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo stopSchedule];
```

:warning: **`#stopSchedule`** will not execute **`#stop`** if the plugin is currently **enabled**.  You must explicitly execute `#stop`.

------------------------------------------------------------------------------


### `(UIBackgroundTaskIdentifier) createBackgroundTask`

Sends a signal to iOS that you wish to perform a long-running task.  The OS will not suspend your app until you signal completion with the [`#stopBackgroundTask`](#stopBackgroundTaskuibackgroundtaskidentifier) method.  

Eg:
```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
UIBackgroundTaskIdentifier taskId = [bgGeo createBackgroundTask];

[self performLongRunningTaskWithCallback:^{
    [bgGeo stopBackgroundTask:taskId];
}];

```

:warning: iOS provides **exactly** 180s of background-running time.  If your long-running task exceeds this time, the plugin has a fail-safe which will automatically [`#finish`](#finishtaskid) your **`taskId`** to prevent the OS from force-killing your application.

------------------------------------------------------------------------------


### `stopBackgroundTask:(UIBackgroundTaskIdentifier)`

Sends a signal to the native OS that your long-running task, addressed by `taskId` returned by `#uibackgroundtaskidentifier-createbackgroundtask` is complete and the OS may proceed to suspend your application if applicable.

Eg:
```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
UIBackgroundTaskIdentifier taskId = [bgGeo createBackgroundTask];

[self performLongRunningTaskWithCallback:^{
    [bgGeo stopBackgroundTask:taskId];
}];

```

------------------------------------------------------------------------------


### `(BOOL) isPowerSaveMode`

Fetches the state of the operating-systems "Power Saving" mode, whether `enabled` or `disabled`.  Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.

:information_source: You can listen to changes in the state of "Power Saving" mode with the **event** [`#powersavechange`](#powersavechange).

iOS Power Saving mode can be engaged manually by the user in **Settings -> Battery** or from an automatic OS dialog.

![](https://dl.dropboxusercontent.com/s/lz3zl2jg4nzstg3/Screenshot%202017-09-19%2010.34.21.png?dl=1)

Eg:
```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
BOOL isPowerSaveEnabled = [bgGeo isPowerSaveMode];

```

------------------------------------------------------------------------------


### `removeListeners`

Remove all event-listeners registered with [`#onEventName`](#zap-events) method.  You're free to add more listeners again after executing **`#removeListeners`**.

```obj-c
// Add location event listener
[bgGeo onLocation:^(TSLocation *location) {
    NSLog(@"[location] %@", [location toDictionary]);
} failure:^(NSError *error) {
    NSLog(@"[location] error: %@", error);
}];
.
.
.
// Remove all listeners
BackgroundGeolocation.removeListeners();

```

------------------------------------------------------------------------------


## :small_blue_diamond: HTTP & Persistence Methods

### `getLocations:(^Block) failure:(^Block)`

Fetch all the locations currently stored in native plugin's SQLite database.  Your **`success`** will receive an `NSArray` of locations 

Eg:
```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo getLocations:^(NSArray* records) {
    NSLog(@"- getLocations success: %@", records);    
} failure:^(NSString* error) {
    NSLog(@"- getLocations failure: %@", error);
}];

```

------------------------------------------------------------------------------


### `(int) getCount`
Fetches count of SQLite locations table `SELECT count(*) from locations`.  The 

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
int count = [bgGeo getCount];
```

------------------------------------------------------------------------------

### `destroyLocations`

Remove all records in plugin's SQLite database.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo destroyLocations];
```

------------------------------------------------------------------------------


### `sync:(^Block) failure:(^Block)`

If the plugin is configured for HTTP with an [`#url`](#config-string-url-undefined) and [`autoSync: false`](#config-string-autosync-true), this method will initiate POSTing the locations currently stored in the native SQLite database to your configured [`#url`](#config-string-url-undefined).  When your HTTP server returns a response of `200 OK`, that record(s) in the database will be DELETED.  

If you configured [`batchSync: true`](#config-bool-batchsync-no), all the locations will be sent to your server in a single HTTP POST request, otherwise the plugin will create execute an HTTP post for **each** location in the database (REST-style).  Your **`callbackFn`** will be executed and provided with an Array of all the locations from the SQLite database.  If you configured the plugin for HTTP (by configuring an [`#url`](#config-nsstring-url-undefined), your **`callbackFn`** will be executed after the HTTP request(s) have completed.  If the plugin failed to sync to your server (possibly because of no network connection), the **`failureFn`** will be called with an `errorMessage`.  If you are **not** using the HTTP features, **`sync`** will delete all records from its SQLite datbase.  Eg:

Your callback will be provided with the following params

#### `^success` Parameters

##### `@param {NSArray} locations`  The list of locations stored in SQLite database.

```ojb-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo sync:^(NSArray* locations) {
    NSLog(@"- Sync success: %@", records);
}, (NSError *error {
    NSLog(@"- Sync error: %@", error);
}];
```

#### `^failure` Parameters

##### `@param {NSError} error`  See `code` for error.


:blue_book: For more information, see [HTTP Guide](http.md)

------------------------------------------------------------------------------


## :small_blue_diamond: Geofencing Methods

### `startGeofences`

Engages the geofences-only `trackingMode`.  In this mode, no active location-tracking will occur -- only geofences will be monitored.  To stop monitoring "geofences" `trackingMode`, simply use the usual `#stop` method.

```obj-c

TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

// Listen to geofence event
[bgGeo onGeofence:^(TSGeofenceEvent *event) {
    NSLog(@"- onGeofence: %@", event);
}];

// Create a geofence
TSGeofence geofence = [[TSGeofence alloc] initWithIdentifier: params[@"identifier"]
                                radius: 200
                              latitude: 37.2334123
                             longitude: 42.2343234
                         notifyOnEntry: YES
                          notifyOnExit: YES
                         notifyOnDwell: YES
                        loiteringDelay: 30000
                                extras: @{@"foo":@"bar"}];

[bgGeo addGeofence:geofence success:^{
    NSLog(@"- addGeofence success");
} failure:^(NSString *error) {
    NSLog(@"- addGeofence failure: %@", error);
}];

// Start monitoring geofences-only mode.
[bgGeo startGeofences];

```

------------------------------------------------------------------------------


### `addGeofence:(TSGeofence*) success:(^block) failure:(^block)`

Adds a geofence to be monitored by the native plugin.  If a geofence *already exists* with the configured **`identifier`**, the previous one will be **deleted** before the new one is inserted.  

#### `TSGeofence` Options

##### `@property {NSString} identifier` The name of your geofence, eg: "Home", "Office"

##### `@property {CLLocationDistance} radius` The radius (meters) of the geofence.  In practice, you should make this >= 100 meters.

##### `@property {CLLocationDegrees} latitude` Latitude of the center-point of the circular geofence.

##### `@property {CLLocationDegrees} longitude` Longitude of the center-point of the circular geofence.

##### `@property {BOOL} notifyOnExit` Whether to listen to EXIT events

##### `@property {BOOL} notifyOnEntry` Whether to listen to ENTER events

##### `@property {BOOL} notifyOnDwell` Whether to listen to DWELL events

##### `@property {double milliseconds} loiteringDelay` When `notifyOnDwell` is `true`, the delay before DWELL event is fired after entering a geofence (@see [Creating and Monitoring Geofences](https://developer.android.com/training/location/geofencing.html))

##### `@property {NSDictionary} extras` Optional arbitrary meta-data.

```obj-c
// Create a geofence
TSGeofence geofence = [[TSGeofence alloc] initWithIdentifier: params[@"identifier"]
                                radius: 200
                              latitude: 37.2334123
                             longitude: 42.2343234
                         notifyOnEntry: YES
                          notifyOnExit: YES
                         notifyOnDwell: YES
                        loiteringDelay: 30000
                                extras: @{@"foo":@"bar"}];

[bgGeo addGeofence:geofence success:^{
    NSLog(@"- addGeofence success");
} failure:^(NSString *error) {
    NSLog(@"- addGeofence failure: %@", error);
}];
```

:information_source: When adding a list-of-geofences, it's about **10* faster** to use [`#addGeofences`](#addgeofencesgeofences-nsarray-success-failure) instead.

:blue_book: See [Geofencing Guide](./geofencing.md) for more information.

#### `^success` Parameters:

*None*

#### `^failure` Parameters

##### `@param {String} errorMessage`

------------------------------------------------------------------------------


### `addGeofences:(NSArray*) success:^(block) failure:^(block)`

Adds a list of geofences to be monitored by the native plugin.  If a geofence *already* exists with the configured `identifier`, the previous one will be **deleted** before the new one is inserted.  The `geofences` param is an `Array` of geofence Objects `{}` with the following params:

##### `@param {NSArray} geofences` An list of TSGeofence configured with the same parmeters as [`#addGeofence`](#config-options)

##### `@param {^block} success` Executed when geofences successfully added.

##### `@param {^block} failure` Executed when failed to add geofence.

Example:

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

TSGeofence geofence1 = [[TSGeofence alloc] initWithIdentifier:@"geofence1"
                                radius: 200
                              latitude: 37.2334123
                             longitude: 42.2343234
                         notifyOnEntry: YES
                          notifyOnExit: YES
                         notifyOnDwell: YES
                        loiteringDelay: 30000
                                extras: @{@"foo":@"bar"}];

TSGeofence geofence2 = [[TSGeofence alloc] initWithIdentifier:@"geofence2"
                                radius: 200
                              latitude: 37.2334123
                             longitude: 42.2343234
                         notifyOnEntry: YES
                          notifyOnExit: YES
                         notifyOnDwell: YES
                        loiteringDelay: 30000
                                extras: @{@"foo":@"bar"}];

// Create an Array to contain geofences
NSArray *geofences = [NSArray new];
[geofences addObject:geofence1];
[geofences addObject:geofence2];

[bgGeo addGeofences:geofences success:^{
    NSLog(@"- addGeofences success");
} failure:^(NSString *error) {
    NSLog(@"- addGeofences failure: %@", error);
}];

```


------------------------------------------------------------------------------


### `removeGeofence:(NSString*) success:^(block) failure:^(block)`

Removes a geofence having the given `{NSString} identifier`.

##### `@param {NSString} identifier` Identifier of geofence to remove.

##### `@param {^block} success` Block called when successfully removed geofence.

##### `@param {^block} failure` Block called when failed to remove geofence

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo removeGeofence:@"HOME" success:^{
    NSLog(@"- Remove geofence success");
} failure:^(NSString *error) {
    NSLog(@"- Remove geofence failure: %@", error);
}]
```

------------------------------------------------------------------------------


### `removeGeofences`

Removes all geofences.

```javascript
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo removeGeofences];
```

------------------------------------------------------------------------------


### `(NSArray*) getGeofences`

Fetch the list of monitored geofences.  Returns an `NSArray` of geofences.  If there are no geofences being monitored, you'll receive an empty Array `[]`.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

NSArray *geofences = [bgGeo getGeofences];
for (TSGeofence *geofence in geofences) {
    NSLog(@"- Geofence: %@", [geofence toDictionary]);
}
```

------------------------------------------------------------------------------


## :small_blue_diamond: Logging Methods

### `getLog:^(block) failure:^(block)`

Fetches the entire contents of the current circular-log and return it to the provided `^block` as an `NSString`.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo getLog:^(NSString* log) {
    NSLog(@"- Log: %@", log);
} failure:^(NSString *error) {
    NSLog(@"- getLog failure: %@", error);
}]
```

------------------------------------------------------------------------------

### `emailLog:(NSString*) success:^(block) failure:^(block)`

Fetch the entire contents of the current circular log and email it to a recipient using the device's native email client.

#### Config Options:

##### `@param {NSString} email`  Email address to send log to.
##### `@param {^block} success`  Executed after successfully emailed.
##### `@param {^block} failure`  Executed on failure

```javascript
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo emailLog:@"foo@bar.com" success:^{
    NSLog(@"- emailLog success");
} failure:^(NSString error) {
    NSLog(@"- emailLog failure: %@", error);
}]
```

### `destroyLog`

Destory the entire contents of Log database.

```obj-c
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];

[bgGeo destroyLog];

```

------------------------------------------------------------------------------


### `playSound:(SystemSoundID)soundId`

Here's a fun one.  The plugin can play a number of OS system sounds for each platform.  For [IOS](http://iphonedevwiki.net/index.php/AudioServices) and [Android](http://developer.android.com/reference/android/media/ToneGenerator.html).

```javascript
// A soundId iOS recognizes
TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
[bgGeo playSound:1303];

```

------------------------------------------------------------------------------

# Classes

## `TSLocation`

```obj-c
// Location types
typedef enum tsLocationType : NSInteger {
    TS_LOCATION_TYPE_MOTIONCHANGE   = 0,
    TS_LOCATION_TYPE_TRACKING       = 1,
    TS_LOCATION_TYPE_CURRENT        = 2,
    TS_LOCATION_TYPE_SAMPLE         = 3,
    TS_LOCATION_TYPE_WATCH          = 4,
    TS_LOCATION_TYPE_GEOFENCE       = 5,
    TS_LOCATION_TYPE_HEARTBEAT      = 6
} tsLocationtype;

@property (nonatomic, readonly) CLLocation* location;
@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *timestamp;
@property (nonatomic, readonly) enum tsLocationType type;
@property (nonatomic, readonly) BOOL isMoving;
@property (nonatomic, readonly) NSDictionary* extras;
@property (nonatomic, readonly) NSDictionary* geofence;
// Battery
@property (nonatomic, readonly) BOOL batteryIsCharging;
@property (nonatomic, readonly) NSNumber *batteryLevel;
// Activity
@property (nonatomic, readonly) NSString *activityType;
@property (nonatomic, readonly) NSNumber *activityConfidence;
// State
@property (nonatomic, readonly) BOOL isSample;
@property (nonatomic, readonly) BOOL isHeartbeat;
@property (nonatomic, readonly) NSNumber *odometer;
@property (nonatomic, readonly) NSString *event;

-(id) initWithLocation:(CLLocation*)location;
-(id) initWithLocation:(CLLocation*)location type:(enum tsLocationType)type extras:(NSDictionary*)extras;
-(id) initWithLocation:(CLLocation*)location geofence:(NSDictionary*)geofenceData;
- (NSString*)toJson:(NSError**)error;
- (NSDictionary*)toDictionary;
```

-------------------------------------------------------------------------------


## `TSCurrentPositionRequest`

```ojb-c
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) double maximumAge;
@property (nonatomic) BOOL persist;
@property (nonatomic) int samples;
@property (nonatomic) CLLocationAccuracy desiredAccuracy;
@property (nonatomic) NSDictionary* extras;
@property (nonatomic, copy) void (^success)(TSLocation*);
@property (nonatomic, copy) void (^failure)(NSError*);

-(instancetype) init;
-(instancetype) initWithSuccess:(void (^)(TSLocation*))success failure:(void (^)(NSError*))failure;

-(instancetype) initWithPersist:(BOOL)persist
                        success:(void (^)(TSLocation*))success
                        failure:(void (^)(NSError*))failure;

-(instancetype) initWithPersist:(BOOL)persist
                        samples:(int)samples
                        success:(void (^)(TSLocation*))success
                        failure:(void (^)(NSError*))failure;

-(instancetype) initWithTimeout:(int)timeout
           maximumAge:(double)maximumAge
              persist:(BOOL)persist
              samples:(int)samples
      desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
               extras:(NSDictionary*)extras
              success:(void (^)(TSLocation*))success
              failure:(void (^)(NSError*))failure;

```

-------------------------------------------------------------------------------


## `TSWatchPositionRequest`

```obj-c

```

-------------------------------------------------------------------------------


## `TSGeofence`

```obj-c
@property (nonatomic) NSString* identifier;
@property (nonatomic) CLLocationDistance radius;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) BOOL notifyOnEntry;
@property (nonatomic) BOOL notifyOnExit;
@property (nonatomic) BOOL notifyOnDwell;
@property (nonatomic) double loiteringDelay;
@property (nonatomic) NSDictionary *extras;

-(instancetype) initWithIdentifier:(NSString*)identifier
                            radius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)lontitude
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                     notifyOnDwell:(BOOL)notifyOnDwell
                    loiteringDelay:(double)loiteringDelay;

-(instancetype) initWithIdentifier:(NSString*)identifier
                            radius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                     notifyOnDwell:(BOOL)notifyOnDwell
                    loiteringDelay:(double)loiteringDelay
                            extras:(NSDictionary*)extras;


- (NSDictionary*) toDictionary;

```

-------------------------------------------------------------------------------


## `TSGeofenceEvent`

```obj-c
@property (nonatomic, readonly) TSLocation* location;
@property (nonatomic, readonly) TSGeofence* geofence;
@property (nonatomic, readonly) CLCircularRegion* region;
@property (nonatomic, readonly) NSString* action;
@property (nonatomic, readonly) BOOL isLoitering;
@property (nonatomic, readonly) BOOL isFinishedLoitering;

-(NSDictionary*)toDictionary;

```

-------------------------------------------------------------------------------

## `TSActivityChangeEvent`

```obj-c
@property (nonatomic, readonly) NSInteger confidence;
@property (nonatomic, readonly) NSString *activity;

```

-------------------------------------------------------------------------------


## `TSHttpEvent`

```obj-c
@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) NSDictionary *requestData;
@property (nonatomic, readonly) NSString *responseText;
@property (nonatomic, readonly) NSError *error;
```

-------------------------------------------------------------------------------


## `TSProviderChangeEvent`

```obj-c
@property (nonatomic, readonly) CLAuthorizationStatus status;
@property (nonatomic, readonly) BOOL gps;
@property (nonatomic, readonly) BOOL network;
@property (nonatomic, readonly) BOOL enabled;
```

-------------------------------------------------------------------------------


## `TSHeartbeatEvent`

```obj-c
@property (nonatomic, readonly) TSLocation* location;
```

-------------------------------------------------------------------------------


## `TSPowerSaveChangeEvent`

```obj-c
@property (nonatomic, readonly) BOOL isPowerSaveMode;
```

-------------------------------------------------------------------------------


## `TSConnectivityChangeEvent`

```obj-c
@property (nonatomic, readonly) BOOL isPowerSaveMode;
```

-------------------------------------------------------------------------------


## `TSEnabledChangeEvent`

```ojb-c
@property (nonatomic, readonly) BOOL isPowerSaveMode;
```

-------------------------------------------------------------------------------