# Adding Passage to Your iOS Application

This article will walk you through adding the passage-ios framework to your iOS applications project.

## Overview

To add Passage to your iOS application you will need to add the passage-ios framework to your applications project and configure it.

Before you add Passage to your application ensure you have completed the following:

- <doc:GetStarted_PassageApplication>
- <doc:GetStarted_AssociatedDomains>

You must have a Passage application setup and an Associated Domain configured in order for Passage to work correctly.

## Add the passage-ios Framework to Your Applications Project

Add the passage-ios package to your application using Swift Package Managerd
<!--Add the passage-ios package to your application using Swift Package Manager or Cocoapods-->

### Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) to install Passage using Xcode:

1. Open your project in Xcode
2. Click "File" -> "Add Packages"
3. Paste the following URL: https://github.com/passageidentity/passage-ios
4. Click "Next" -> "Next" -> "Finish"

..or..

- Paste this url into the Swift Package Manager search bar in Xcode

```
https://github.com/passageidentity/passage-ios
```

<!--### Cocoapods-->
<!---->
<!--- Git clone this repo-->
<!--- In your app, update your Podfile like this:-->
<!---->
<!--```-->
<!--platform :ios, '16.0' // Must be iOS 16.0 or later-->
<!---->
<!--target 'My App' do-->
<!--  use_frameworks!-->
<!---->
<!--  # Pods for MyApp-->
<!--  pod 'Passage', :path => '../passage-ios' // The relative path to this private passage-ios library-->
<!---->
<!--end-->
<!--```-->
<!---->
<!--- Run `pod install`-->
<!--  <br>-->
<!--  NOTE: This is NOT yet working in Xcode 14 beta on M1 Macs.-->


## Configure the passage-ios Framework

To use Passage in your application you will need to set the Application Id and Authentication Origin for Passage to use.

This is done by specifying the values in a Passage.plist file

#### Configure Application Id and Authentication Origin in a plist

1. Create a plist file named Passage.plist in your application bundle.
2. Add a appId key with the value of your Passage Application Id (can be found in the [passage console](https://console.passage.id))
3. Add a authOrigin key with the value of your applications domain. (can be found in the [passage console](https://console.passage.id))

Your Passage.plist should look similiar to the following.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>appId</key>
    <string>KZ520QJSiFRLvbBvraaAgYuf</string>
    <key>authOrigin</key>
    <string>try.passage.id</string>
</dict>
</plist>

```

## What's next

Now that you have your Passage Application setup, your associated domains configured, and passage-ios has been added to your project, what's next?

- Check out the guides to add Registration and Log In capabilities to your application:
    - <doc:Guide_Registration>
    - <doc:Guide_Login>

- Secure your backend:
    - <doc:GetStarted_Backend>




