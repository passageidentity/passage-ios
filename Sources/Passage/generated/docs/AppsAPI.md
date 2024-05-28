# AppsAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getApp**](AppsAPI.md#getapp) | **GET** /apps/{app_id} | Get App


# **getApp**
```swift
    open class func getApp(appId: String, completion: @escaping (_ data: GetAppResponse?, _ error: Error?) -> Void)
```

Get App

Get information about an application.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get App
AppsAPI.getApp(appId: appId) { (response, error) in
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

[**GetAppResponse**](GetAppResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

