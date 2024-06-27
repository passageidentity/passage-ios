# OpenIDAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getOpenIdConfiguration**](OpenIDAPI.md#getopenidconfiguration) | **GET** /apps/{app_id}/.well-known/openid-configuration | Get OpenID Configuration


# **getOpenIdConfiguration**
```swift
    open class func getOpenIdConfiguration(appId: String, completion: @escaping (_ data: OpenIdConfiguration?, _ error: Error?) -> Void)
```

Get OpenID Configuration

Get OpenID Configuration for an app.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get OpenID Configuration
OpenIDAPI.getOpenIdConfiguration(appId: appId) { (response, error) in
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

### Return type

[**OpenIdConfiguration**](OpenIdConfiguration.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

