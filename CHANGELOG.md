# Change Log

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
