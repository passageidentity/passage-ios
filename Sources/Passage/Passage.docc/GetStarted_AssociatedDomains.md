# Associated Domains

Before you can use the passage-ios framework in your application you will need to setup an Associated Domain.

## Overview

In order to use Passage in your application you will need to establish a secure association between your iOS Application and your application's domain. Setting up an associated domain and adding the required entitlements to your project establishes this association. This association needs to be established before using Passkeys or Magic Links in your application.

Establishing this association is an easy 2 step process that involves hosting a file on your domain and then adding the appropriate entitlements to your application's project.

It is out of scope for this document to provide all the details for supporting associated domains, so for all the details on Supporting Associated domains see [Supporting Associated Domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains).

Note: Even if you will not use Passkeys you will need to setup an associated domain for your application in order to use universal links for magic link support.

## Step 1: Add the Associated Domain File to Your Website

The website hosting your domain will need to serve a file named 'apple-app-site-association' in the '.well-known' in the root of your website.

The full path to this file should look like:
```
https://<fully qualified domain>/.well-known/apple-app-site-association
```

Apple's CDN will request this file to verify that the domain is associated with your iOS Application.

Sample apple-app-site-association:

```
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "LKQWMG6BWA.id.passage.example-ios",
        "paths": [
          "*"
        ]
      }
    ]
  },
  "webcredentials": {
    "apps": [
      "LKQWMG6BWA.id.passage.example-ios"
    ]
  }
}

```

This sample configures web credentials and universal links for your application. You will need to replace the appIDs in the above example with the appID of your application. This sample will configure universal links so that all links to your domain will open in your iOS Application if the user has it installed.

For more information see [Supporting Associated Domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains).


## Step 2: Add associated domain entitlements 

The next step is to enable the appropriate entitlements in your project. These entitlements will associate your iOS Application with your domain and use the apple-app-site-association file to verify this association.

To add the entitlements to your application:

1. Open the targets 'Signing & Capabilities' tab in xCode
2. Click Add(+) at the bottom of the domains table
3. Replace the placeholder domain with your authentication origin

![Associated Domain Config](AssociatedDomainsConfig)

* Passkeys require the **'webcredentials'** entitlement
* Universal links require the **'applinks'** entitlement

For more information see [Supporting Associated Domains](https://developer.apple.com/documentation/xcode/supporting-associated-domains) for more detailed information.
