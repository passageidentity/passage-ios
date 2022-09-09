# Passage Application Setup

Before your can add Passage to your application you will need to have a Passage application setup. This article will show you how to get it done.

## Overview

Before you can add Passage to your iOS Application you will need to create a new Passage Application or use an existing one.

## Creating a new Passage App

To create an app, first login or create an account for the Passage Console at [https://console.passage.id/register](https://console.passage.id/register). When you first sign up, you will be redirected to your homepage that includes an example application to explore. To create your first new application, select the "Create New App" button on the home page. Give your application a name and then provide the following fields:

* Authentication Origin - the domain that Passage will run on and should match the domain your application will be associated with.
* Redirect URL - the path you want to direct users to after successful login

For example, if you are building a local test app, your settings will probably look something like this:

* Authentication Origin - http://localhost:8080
* Redirect URL - /dashboard or /

Once you've created your application, copy the Application ID from the dashboard.

## Using an existing Passage App

If you already have a Passage Application that you would like to use you will need to get the Passage application id and the Authentication Origin.

The Authentication Origin should match the domain your iOS application will be associated with.

1. Login to the Passage Console at [https://console.passage.id/register](https://console.passage.id/register)
2. Select the Passage Application associated with your application.
3. You can find your Application Id in the App Info Card on the Applications Dashboard.
![Passage Application Id](ConsoleAppId)
4. You can find your Authentication Origin by navigating to "Settings" -> "General Settings"
![Passage Auth Origin](ConsoleAuthOrigin)
