# MagicLinkAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateMagicLink**](MagicLinkAPI.md#activatemagiclink) | **PATCH** /apps/{app_id}/magic-link/activate | Authenticate Magic Link
[**magicLinkStatus**](MagicLinkAPI.md#magiclinkstatus) | **POST** /apps/{app_id}/magic-link/status | Magic Link Status


# **activateMagicLink**
```swift
    open class func activateMagicLink(appId: String, activateMagicLinkRequest: ActivateMagicLinkRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Authenticate Magic Link

Authenticate a magic link for a user. This endpoint checks that the magic link is valid, then returns an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let activateMagicLinkRequest = ActivateMagicLinkRequest(magicLink: "magicLink_example") // ActivateMagicLinkRequest | User Data

// Authenticate Magic Link
MagicLinkAPI.activateMagicLink(appId: appId, activateMagicLinkRequest: activateMagicLinkRequest) { (response, error) in
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
 **activateMagicLinkRequest** | [**ActivateMagicLinkRequest**](ActivateMagicLinkRequest.md) | User Data | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **magicLinkStatus**
```swift
    open class func magicLinkStatus(appId: String, getMagicLinkStatusRequest: GetMagicLinkStatusRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Magic Link Status

Check if a magic link has been activated yet or not. Once the magic link has been activated, this endpoint will return an authentication token for the user. This endpoint can be used to initiate a login on one device and then poll and wait for the login to complete on another device.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let getMagicLinkStatusRequest = GetMagicLinkStatusRequest(id: "id_example") // GetMagicLinkStatusRequest | Magic Link ID

// Magic Link Status
MagicLinkAPI.magicLinkStatus(appId: appId, getMagicLinkStatusRequest: getMagicLinkStatusRequest) { (response, error) in
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
 **getMagicLinkStatusRequest** | [**GetMagicLinkStatusRequest**](GetMagicLinkStatusRequest.md) | Magic Link ID | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

