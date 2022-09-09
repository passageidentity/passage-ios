# Adding Passage To Your Backend

This article will walk you through securing your backend with Passage and the changes it will require to your frontend.

## Overview

Using passage-ios in your application will provide your users with Auth Tokens. Now we need to enable our back-end to validate the JWT for authenticated paths. 

Passage provides back-end SDKs for: 
 - [Node](https://docs.passage.id/backend/overview/node) 
 - [Go](https://docs.passage.id/backend/overview/go) 
 - [Python](https://docs.passage.id/backend/overview/python) 
 - [Ruby](https://docs.passage.id/backend/overview/ruby). 

Follow the guide of your choice to implement server side authentication. 

## Send Auth Token With Each Backend Request

Once your backend is secured by Passage you will need to pass the user's auth token on each request. This is generally done by adding an 'Authorization' header to each request being made to the backend from the frontend.

