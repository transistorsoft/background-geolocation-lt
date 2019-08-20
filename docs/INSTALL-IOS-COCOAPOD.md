## iOS Cocoapods Installation

You will have to install the plugin by manually downloading [a Release](https://github.com/transistorsoft/background-geolocation-lt/releases) from this repository.  The plugin is not currently submitted to a package manager (eg: jCenter)

### `Podfile`

Add the following `pod` to your `Podfile`, providing the path to where you installed the `background-geolocation-lt` SDK:

```ruby
pod 'BackgroundGeolocation', :path => '../Libraries/background-geolocation-lt/ios/BackgroundGeolocation.podspec'
```

```bash
$ pod install
```

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

