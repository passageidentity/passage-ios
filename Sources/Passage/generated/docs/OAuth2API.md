# OAuth2API

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appleOauth2Callback**](OAuth2API.md#appleoauth2callback) | **POST** /apps/{app_id}/social/oauth2_callback | Handle Apple&#39;s OAuth2 callback
[**appleOauth2CallbackDefaultDev**](OAuth2API.md#appleoauth2callbackdefaultdev) | **POST** /social/oauth2_callback | Handle Apple&#39;s OAuth2 callback for the default developer credentials
[**currentuserSocialLinkAccount**](OAuth2API.md#currentusersociallinkaccount) | **GET** /apps/{app_id}/currentuser/social/link_account | Link an existing account to an OAuth2 connection.
[**exchangeSocialIdToken**](OAuth2API.md#exchangesocialidtoken) | **POST** /apps/{app_id}/social/id_token | Exchange native mobile identity token for an auth token.
[**exchangeSocialToken**](OAuth2API.md#exchangesocialtoken) | **GET** /apps/{app_id}/social/token | Exchange OAuth2 connection data for an auth token.
[**getAuthorize**](OAuth2API.md#getauthorize) | **GET** /apps/{app_id}/social/authorize | Kick off OAuth2 flow
[**oauth2Callback**](OAuth2API.md#oauth2callback) | **GET** /apps/{app_id}/social/oauth2_callback | Handle OAuth2 callback
[**oauth2CallbackDefaultDev**](OAuth2API.md#oauth2callbackdefaultdev) | **GET** /social/oauth2_callback | Handle OAuth2 callback for the default developer credentials


# **appleOauth2Callback**
```swift
    open class func appleOauth2Callback(appId: String, state: String, code: String? = nil, idToken: String? = nil, user: String? = nil, error: ModelError_appleOauth2Callback? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Handle Apple's OAuth2 callback

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let state = "state_example" // String | The state contained in the authorization request.
let code = "code_example" // String | A single-use authorization grant code that’s valid for five minutes. (optional)
let idToken = "idToken_example" // String | A JWT containing the user’s identity information. (optional)
let user = "user_example" // String | A JSON string containing the data requested in the scope property. (optional)
let error = "error_example" // String | The error returned by Apple. (optional)

// Handle Apple's OAuth2 callback
OAuth2API.appleOauth2Callback(appId: appId, state: state, code: code, idToken: idToken, user: user, error: error) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **state** | **String** | The state contained in the authorization request. | 
 **code** | **String** | A single-use authorization grant code that’s valid for five minutes. | [optional] 
 **idToken** | **String** | A JWT containing the user’s identity information. | [optional] 
 **user** | **String** | A JSON string containing the data requested in the scope property. | [optional] 
 **error** | **String** | The error returned by Apple. | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appleOauth2CallbackDefaultDev**
```swift
    open class func appleOauth2CallbackDefaultDev(state: String, code: String? = nil, idToken: String? = nil, user: String? = nil, error: ModelError_appleOauth2CallbackDefaultDev? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Handle Apple's OAuth2 callback for the default developer credentials

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let state = "state_example" // String | The state contained in the authorization request.
let code = "code_example" // String | A single-use authorization grant code that’s valid for five minutes. (optional)
let idToken = "idToken_example" // String | A JWT containing the user’s identity information. (optional)
let user = "user_example" // String | A JSON string containing the data requested in the scope property. (optional)
let error = "error_example" // String | The error returned by Apple. (optional)

// Handle Apple's OAuth2 callback for the default developer credentials
OAuth2API.appleOauth2CallbackDefaultDev(state: state, code: code, idToken: idToken, user: user, error: error) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String** | The state contained in the authorization request. | 
 **code** | **String** | A single-use authorization grant code that’s valid for five minutes. | [optional] 
 **idToken** | **String** | A JWT containing the user’s identity information. | [optional] 
 **user** | **String** | A JSON string containing the data requested in the scope property. | [optional] 
 **error** | **String** | The error returned by Apple. | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **currentuserSocialLinkAccount**
```swift
    open class func currentuserSocialLinkAccount(appId: String, code: String, verifier: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Link an existing account to an OAuth2 connection.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let code = "code_example" // String | The code given from the OAuth2 redirect
let verifier = "verifier_example" // String | The verifier the client originally sent to the OAuth2 provider

// Link an existing account to an OAuth2 connection.
OAuth2API.currentuserSocialLinkAccount(appId: appId, code: code, verifier: verifier) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **code** | **String** | The code given from the OAuth2 redirect | 
 **verifier** | **String** | The verifier the client originally sent to the OAuth2 provider | 

### Return type

Void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exchangeSocialIdToken**
```swift
    open class func exchangeSocialIdToken(appId: String, idTokenRequest: IdTokenRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Exchange native mobile identity token for an auth token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let idTokenRequest = IdTokenRequest(code: "code_example", idToken: "idToken_example", connectionType: "connectionType_example") // IdTokenRequest | 

// Exchange native mobile identity token for an auth token.
OAuth2API.exchangeSocialIdToken(appId: appId, idTokenRequest: idTokenRequest) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **idTokenRequest** | [**IdTokenRequest**](IdTokenRequest.md) |  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exchangeSocialToken**
```swift
    open class func exchangeSocialToken(appId: String, code: String, verifier: String, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Exchange OAuth2 connection data for an auth token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let code = "code_example" // String | The code given from the OAuth2 redirect
let verifier = "verifier_example" // String | The verifier the client originally sent to the OAuth2 provider

// Exchange OAuth2 connection data for an auth token.
OAuth2API.exchangeSocialToken(appId: appId, code: code, verifier: verifier) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **code** | **String** | The code given from the OAuth2 redirect | 
 **verifier** | **String** | The verifier the client originally sent to the OAuth2 provider | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAuthorize**
```swift
    open class func getAuthorize(appId: String, redirectUri: String, codeChallenge: String, codeChallengeMethod: String, connectionType: ConnectionType_getAuthorize, state: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Kick off OAuth2 flow

Kick off OAuth2 flow with connection provider request params described in https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let redirectUri = "redirectUri_example" // String | The URL to redirect to after the OAuth2 flow is complete.
let codeChallenge = "codeChallenge_example" // String | Code challenge.
let codeChallengeMethod = "codeChallengeMethod_example" // String | Code challenge method.
let connectionType = "connectionType_example" // String | connection type; google, github, apple, or passage to login with
let state = "state_example" // String | The state to pass through to the redirect URI. (optional)

// Kick off OAuth2 flow
OAuth2API.getAuthorize(appId: appId, redirectUri: redirectUri, codeChallenge: codeChallenge, codeChallengeMethod: codeChallengeMethod, connectionType: connectionType, state: state) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **redirectUri** | **String** | The URL to redirect to after the OAuth2 flow is complete. | 
 **codeChallenge** | **String** | Code challenge. | 
 **codeChallengeMethod** | **String** | Code challenge method. | 
 **connectionType** | **String** | connection type; google, github, apple, or passage to login with | 
 **state** | **String** | The state to pass through to the redirect URI. | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **oauth2Callback**
```swift
    open class func oauth2Callback(appId: String, code: String, state: String? = nil, error: ModelError_oauth2Callback? = nil, errorDescription: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Handle OAuth2 callback

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let code = "code_example" // String | The authorization code returned by the OAuth2 provider.
let state = "state_example" // String | The state returned by the OAuth2 provider. (optional)
let error = "error_example" // String | The error returned by the OAuth2 provider. (optional)
let errorDescription = "errorDescription_example" // String | The error description returned by the OAuth2 provider. (optional)

// Handle OAuth2 callback
OAuth2API.oauth2Callback(appId: appId, code: code, state: state, error: error, errorDescription: errorDescription) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String** | App ID | 
 **code** | **String** | The authorization code returned by the OAuth2 provider. | 
 **state** | **String** | The state returned by the OAuth2 provider. | [optional] 
 **error** | **String** | The error returned by the OAuth2 provider. | [optional] 
 **errorDescription** | **String** | The error description returned by the OAuth2 provider. | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **oauth2CallbackDefaultDev**
```swift
    open class func oauth2CallbackDefaultDev(code: String, state: String? = nil, error: ModelError_oauth2CallbackDefaultDev? = nil, errorDescription: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Handle OAuth2 callback for the default developer credentials

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let code = "code_example" // String | The authorization code returned by the OAuth2 provider.
let state = "state_example" // String | The state returned by the OAuth2 provider. (optional)
let error = "error_example" // String | The error returned by the OAuth2 provider. (optional)
let errorDescription = "errorDescription_example" // String | The error description returned by the OAuth2 provider. (optional)

// Handle OAuth2 callback for the default developer credentials
OAuth2API.oauth2CallbackDefaultDev(code: code, state: state, error: error, errorDescription: errorDescription) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String** | The authorization code returned by the OAuth2 provider. | 
 **state** | **String** | The state returned by the OAuth2 provider. | [optional] 
 **error** | **String** | The error returned by the OAuth2 provider. | [optional] 
 **errorDescription** | **String** | The error description returned by the OAuth2 provider. | [optional] 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

