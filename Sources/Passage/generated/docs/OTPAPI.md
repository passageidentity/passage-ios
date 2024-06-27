# OTPAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateOneTimePasscode**](OTPAPI.md#activateonetimepasscode) | **POST** /apps/{app_id}/otp/activate | Authenticate OTP


# **activateOneTimePasscode**
```swift
    open class func activateOneTimePasscode(appId: String, activateOneTimePasscodeRequest: ActivateOneTimePasscodeRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Authenticate OTP

Authenticate a one-time passcode for a user. This endpoint checks that the one-time passcode is valid, then returns an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let activateOneTimePasscodeRequest = ActivateOneTimePasscodeRequest(otp: "otp_example", otpId: "otpId_example") // ActivateOneTimePasscodeRequest | User Data

// Authenticate OTP
OTPAPI.activateOneTimePasscode(appId: appId, activateOneTimePasscodeRequest: activateOneTimePasscodeRequest) { (response, error) in
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
 **activateOneTimePasscodeRequest** | [**ActivateOneTimePasscodeRequest**](ActivateOneTimePasscodeRequest.md) | User Data | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

