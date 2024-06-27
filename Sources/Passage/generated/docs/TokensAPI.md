# TokensAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**refreshAuthToken**](TokensAPI.md#refreshauthtoken) | **POST** /apps/{app_id}/tokens | Creates new auth and refresh token
[**revokeRefreshToken**](TokensAPI.md#revokerefreshtoken) | **DELETE** /apps/{app_id}/tokens | Revokes refresh token


# **refreshAuthToken**
```swift
    open class func refreshAuthToken(appId: String, refreshAuthTokenRequest: RefreshAuthTokenRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Creates new auth and refresh token

Creates and returns a new auth token and a new refresh token

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let refreshAuthTokenRequest = RefreshAuthTokenRequest(refreshToken: "refreshToken_example") // RefreshAuthTokenRequest | Refresh token

// Creates new auth and refresh token
TokensAPI.refreshAuthToken(appId: appId, refreshAuthTokenRequest: refreshAuthTokenRequest) { (response, error) in
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
 **refreshAuthTokenRequest** | [**RefreshAuthTokenRequest**](RefreshAuthTokenRequest.md) | Refresh token | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeRefreshToken**
```swift
    open class func revokeRefreshToken(appId: String, refreshToken: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Revokes refresh token

Revokes the refresh token

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let refreshToken = "refreshToken_example" // String | Refresh token

// Revokes refresh token
TokensAPI.revokeRefreshToken(appId: appId, refreshToken: refreshToken) { (response, error) in
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
 **refreshToken** | **String** | Refresh token | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

