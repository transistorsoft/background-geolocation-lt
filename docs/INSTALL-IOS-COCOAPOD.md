## iOS Cocoapods Installation

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

### `Podfile`

Add the following `pod` to your `Podfile`, providing the path to the location where you installed the `background-geolocation-lt` SDK:

```ruby
pod 'BackgroundGeolocation', :path => '../lib/background-geolocation-lt/ios/BackgroundGeolocation.podspec'
```

```bash
$ pod install
```

## Configure Background Capabilities

With `YourApp.xcworkspace` open in XCode, add the following **Background Modes Capabilities**:

- [x] Location updates
- [x] Background fetch
- [x] Audio (**optional for debug-mode sound FX**)

![](https://dl.dropboxusercontent.com/s/5o6czxuvgzv9f3z/background-capabilities.png?dl=1)

## Info.plist

Edit **`Info.plist`**.  Add the following **three Privacy Descriptions**.  These descriptions will appear on popups requesting permission from user for *Motion Usage* and *Location Usage*

![](https://dl.dropboxusercontent.com/s/nrm5xfpcpj70itj/plist-permissions.png?dl=1)

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

