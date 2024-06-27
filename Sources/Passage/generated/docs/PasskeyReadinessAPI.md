# PasskeyReadinessAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createPasskeyReadiness**](PasskeyReadinessAPI.md#createpasskeyreadiness) | **POST** /analytics/passkey-readiness | Create Passkey Readiness Analytics


# **createPasskeyReadiness**
```swift
    open class func createPasskeyReadiness(createPasskeyReadinessRequest: CreatePasskeyReadinessRequest, userAgent: String? = nil, origin: String? = nil, deviceOS: String? = nil, deviceOSVersion: String? = nil, appIdentifier: String? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Create Passkey Readiness Analytics

Sends device's WebAuthn passkey readiness metrics

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let createPasskeyReadinessRequest = CreatePasskeyReadinessRequest(deviceId: "deviceId_example", securityKey: false, platform: false, syncedCredential: false, crossDeviceCredential: false, conditionalUi: false) // CreatePasskeyReadinessRequest | Passkey readiness metrics
let userAgent = "userAgent_example" // String |  (optional)
let origin = "origin_example" // String | url for passkey readiness (optional)
let deviceOS = "deviceOS_example" // String | device os - mobile only (optional)
let deviceOSVersion = "deviceOSVersion_example" // String | device os version - mobile only (optional)
let appIdentifier = "appIdentifier_example" // String | app identifier - mobile only (optional)

// Create Passkey Readiness Analytics
PasskeyReadinessAPI.createPasskeyReadiness(createPasskeyReadinessRequest: createPasskeyReadinessRequest, userAgent: userAgent, origin: origin, deviceOS: deviceOS, deviceOSVersion: deviceOSVersion, appIdentifier: appIdentifier) { (response, error) in
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
 **createPasskeyReadinessRequest** | [**CreatePasskeyReadinessRequest**](CreatePasskeyReadinessRequest.md) | Passkey readiness metrics | 
 **userAgent** | **String** |  | [optional] 
 **origin** | **String** | url for passkey readiness | [optional] 
 **deviceOS** | **String** | device os - mobile only | [optional] 
 **deviceOSVersion** | **String** | device os version - mobile only | [optional] 
 **appIdentifier** | **String** | app identifier - mobile only | [optional] 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

