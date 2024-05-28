# JWKSAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getJwks**](JWKSAPI.md#getjwks) | **GET** /apps/{app_id}/.well-known/jwks.json | Get JWKS


# **getJwks**
```swift
    open class func getJwks(appId: String, completion: @escaping (_ data: JWKResponse?, _ error: Error?) -> Void)
```

Get JWKS

Get JWKS for an app. KIDs in the JWT can be used to match the appropriate JWK, and use the JWK's public key to verify the JWT.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get JWKS
JWKSAPI.getJwks(appId: appId) { (response, error) in
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

[**JWKResponse**](JWKResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

