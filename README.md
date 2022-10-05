<img src="https://storage.googleapis.com/passage-docs/passage-logo-gradient.svg" alt="Passage logo" style="width:250px;"/>

- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Setup Guide](#setup-guide)
- [SDK Methods](#sdk-methods)
- [Examples](#examples)


# Overview

**NOTE: passage-ios is currently in beta.**

The [Passage](https://passage.id) iOS framework provides an easy to use SDK interface to implement a [Passkey](https://developer.apple.com/passkeys/) focused authentication expierence for native apps built in Swift. 

 Want to see the end result before the setup work? 

 To see a code level implementation, checkout and run our [Swift Example App](https://github.com/passageidentity/example-ios)  

 To see a quick demo reach out to our team on [Discord](https://discord.gg/9CC7vHJEku) and ask for a link to our TestFlight app. 


**Note:** This package is currently in Beta - breaking changes may occur. To report a bug please create a Github Issue or get in touch with our team on [Discord](https://discord.gg/9CC7vHJEku). 

# Requirements

### Xcode
Compatile with [Xcode](https://developer.apple.com/xcode/) version 14+.

### iOS Version

The Passage-iOS SDK is supported for iOS version 14+. However, Passkeys are only supported on iOS v16+.

| iOS Version 	| Passkey Login 	 | Magic Link Login 	|
|-------------	|      :----:      |        :----: 	    |
| v16.x       	|       ✅       	|           ✅        |
| v15.x     	|        ❌       	|           ✅      	 |
| v14.x       	|        ❌       	|           ✅        |

# Installation

Add the passage-ios package to your app via SwiftPackage Manager
<!--Add the passage-ios package to your app via SwiftPackage Manager or Cocoapods-->
## Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/)

1. Open your project in Xcode
2. Click "File" -> "Add Packages"
3. Paste the following URL: https://github.com/passageidentity/passage-ios
4. Click "Next" -> "Next" -> "Finish"

..or..

- Paste this url into the Swift Package Manager search bar in Xcode

```
https://github.com/passageidentity/passage-ios
```

<!--## Cocoapods-->
<!---->
<!--- Git clone this repo-->
<!--- In your app, update your Podfile:-->
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

- Run `pod install`
  <br>
  NOTE: This is NOT yet working in Xcode 14 beta on M1 Macs.

# Setup Guide

View the [Documentation Catalog](https://passageidentity.github.io/passage-ios/documentation/passage/) or dowload the [Documentation Catalog](docs/Passage.doccarchive.zip) to view in the Xcode Document Viewer. Follow the `Getting Started` guide which consists the following steps:


1. Setup your Passage application
2. Associate your domain with your application
3. Configure your application in Xcode
4. Enable your backend to validate JWTs
5. Send auth token on API requests

# Initialization & Usage
Import the Passage package into any source file that will use the iOS SDK.

```
import Passage
```

View the [Documentation Catalog](https://passageidentity.github.io/passage-ios/documentation/passage/) or dowload the [Documentation Catalog](docs/Passage.doccarchive.zip) to view in the Xcode Document Viewer, and navigate to the `Getting Started` guide for a detailed step by step guide.


# SDK Methods 
The package provides both Type Methods and Instance Methods. These methods provide everything you will need to register, login, and manage users on your application. The SDK methods below provide a high level overview of available actions. For the full a full list of available methos and their signatures view the [Documentation Catalog](https://passageidentity.github.io/passage-ios/documentation/passage/) or dowload the [Documentation Catalog](docs/Passage.doccarchive.zip) to view in the Xcode Document Viewer and navigate to `Classes`.

## PassageAuth

PassageAuth is the primary class you will work with. It provides the following:

- Registration
- Login
- Sign Out (if you use a Passage Token Store)
- User Management
- App Details
- And More
 
# Examples
## Registration

See the `User Registration` guide in the [Documentation Catalog](https://passageidentity.github.io/passage-ios/documentation/passage/) or dowload the [Documentation Catalog](docs/Passage.doccarchive.zip) to view in the Xcode Document Viewer.

## Login

See the `Login` guide in the [Documentation Catalog](https://passageidentity.github.io/passage-ios/documentation/passage/) or dowload the [Documentation Catalog](docs/Passage.doccarchive.zip) to view in the Xcode Document Viewer.

# Resources

## Online Documentation

[Documentation Catalog Online](https://passageidentity.github.io/passage-ios/documentation/passage/)

## Documentation Catalog

This package includes a documentation catalog that can be viewed in the Xcode developer documentation browser.

To generate the documentation catalog, in Xcode click "Product" -> "Build Documentation", it should open the Documentation Viewer, if not select "Window" -> "Developer Documentation"

Download the [DocC Archive](docs/Passage.doccarchive.zip)
