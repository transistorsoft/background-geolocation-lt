
# iOS Installation

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

Create a folder in the root of your application project, eg: `/Libraries` and place the extracted **`background-geolocation`** folder into it:

eg: :open_file_folder: **`Libraries/background-geolocation-lt`**

## Install CocoaLumberjack

`BackgroundGeolocation` uses [`CocoaLumberjack`](https://github.com/CocoaLumberjack/CocoaLumberjack) for logging.  Install it now:
#### A.  Cocoapods Installation
```ruby
pod 'CocoaLumberjack'
```

#### B.  Carthage
```
github "CocoaLumberjack/CocoaLumberjack"
```

#### C.  Manual
1.  Right click on your Project root ➜ **New Group: "Libraries"**
![](https://dl.dropboxusercontent.com/s/ksdrhds0bslo6eo/new-group-libraries.png?dl=1)

2. [Download latest release](https://github.com/CocoaLumberjack/CocoaLumberjack/releases) of `CocaoLumberjack`.  Extract to&nbsp;&nbsp;:open_file_folder:**Libraries** folder you just created.

3.  Right click&nbsp;&nbsp;:open_file_folder:**Libraries ➜ Add file to <...>**.  Add `Lumberjack.xcodeproj`:
![](https://dl.dropboxusercontent.com/s/k8tjh4c4l70n1x4/add-file-cocoa-lumberjack.png?dl=1)
![](https://dl.dropboxusercontent.com/s/rvlz2doz5tv1avq/select-file-cocoa-lumberjack.png?dl=1)

4.  Build Phases Link Binary With Libraries ➜ Add **`libCocoaLumberjack.a`**
![](https://dl.dropboxusercontent.com/s/vyfp5jh1od6915e/build-phases-libCocoaLumberjack.png?dl=1)

## Install Background Geolocation SDKs

Install the following **two** Cocoa Frameworks:
- `TSLocationManager.framework`
- `TSBackgroundFetch.framework`

Right-click&nbsp;&nbsp;:open_file_folder:**Frameworks** ➜ **`Add Files to...`**
- Browse to `Libraries/background-geolocation-lt/ios/BackgroundGeolocation`
![](https://dl.dropboxusercontent.com/s/fmrhfvdwszshbd7/add-files-frameworks.png?dl=1)
![](https://dl.dropboxusercontent.com/s/cq56x5hijx8v6y6/select-file-TSLocationManager-TSBackgroundFetch.png?dl=1)


## Build Phases ➜ Link Binary With Libraries

- Add the following Cocoa framework dependencies to your target's `Link Binary With Libraries` build phase:
    - **`libsqlite3.tbd`**
    - **`libz.tbd`**

![](https://dl.dropboxusercontent.com/s/b50j6lekmmg3hb9/link-binaries-libsqlite-libz.png?dl=1)

## Configure Background Capabilities

With `YourApp.xcworkspace` open in XCode, add the following **Background Modes Capabilities**:

- [x] Location updates
- [x] Background fetch
- [x] Audio (**optional for debug-mode sound FX**)

![](https://dl.dropbox.com/s/c3vm8x0wgrfn9f4/ios-setup-background-modes.png?dl=1)

## Info.plist

Edit **`Info.plist`**.  Add the following items (Set **Value** as desired):

| Key | Type | Value |
|-----|-------|-------------|
| *Privacy - Location Always and When in Use Usage Description* | `String` | *CHANGEME: Location required in background* |
| *Privacy - Location When in Use Usage Description* | `String` | *CHANGEME: Location required when app is in use* |
| *Privacy - Motion Usage Description* | `String` | *CHANGEME: Motion permission helps detect when device in in-motion* |

![](https://dl.dropbox.com/s/9non3j83jj0rimu/ios-setup-plist-strings.png?dl=1)

## Background Fetch API

The Background Geolocation SDK is integrated with the [iOS Background Fetch API](https://developer.apple.com/documentation/uikit/core_app/managing_your_app_s_life_cycle/preparing_your_app_to_run_in_the_background/updating_your_app_with_background_app_refresh).

In Your **`AppDelegate.h`**, add the following block:

```obj-c
@import TSBackgroundFetch;

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    TSBackgroundFetch *fetchManager = [TSBackgroundFetch sharedInstance];
    [fetchManager performFetchWithCompletionHandler:completionHandler applicationState:application.applicationState];
}
```

You can now [import and build](../README.md#example).
