# LoginAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**loginMagicLink**](LoginAPI.md#loginmagiclink) | **POST** /apps/{app_id}/login/magic-link | Login with Magic Link
[**loginOneTimePasscode**](LoginAPI.md#loginonetimepasscode) | **POST** /apps/{app_id}/login/otp | Login with OTP
[**loginWebauthnFinish**](LoginAPI.md#loginwebauthnfinish) | **POST** /apps/{app_id}/login/webauthn/finish | Finish WebAuthn Login
[**loginWebauthnStart**](LoginAPI.md#loginwebauthnstart) | **POST** /apps/{app_id}/login/webauthn/start | Start WebAuthn Login


# **loginMagicLink**
```swift
    open class func loginMagicLink(appId: String, loginMagicLinkRequest: LoginMagicLinkRequest, completion: @escaping (_ data: LoginMagicLinkResponse?, _ error: Error?) -> Void)
```

Login with Magic Link

Send a login email or SMS to the user. The user will receive an email or text with a link to complete their login.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let loginMagicLinkRequest = LoginMagicLinkRequest(identifier: "identifier_example", language: "language_example", magicLinkPath: "magicLinkPath_example") // LoginMagicLinkRequest | User Data

// Login with Magic Link
LoginAPI.loginMagicLink(appId: appId, loginMagicLinkRequest: loginMagicLinkRequest) { (response, error) in
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
 **loginMagicLinkRequest** | [**LoginMagicLinkRequest**](LoginMagicLinkRequest.md) | User Data | 

### Return type

[**LoginMagicLinkResponse**](LoginMagicLinkResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginOneTimePasscode**
```swift
    open class func loginOneTimePasscode(appId: String, loginOneTimePasscodeRequest: LoginOneTimePasscodeRequest, completion: @escaping (_ data: OneTimePasscodeResponse?, _ error: Error?) -> Void)
```

Login with OTP

Send a login email or SMS to the user. The user will receive an email or text with a one-time passcode to complete their login.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let loginOneTimePasscodeRequest = LoginOneTimePasscodeRequest(identifier: "identifier_example", language: "language_example") // LoginOneTimePasscodeRequest | User Data

// Login with OTP
LoginAPI.loginOneTimePasscode(appId: appId, loginOneTimePasscodeRequest: loginOneTimePasscodeRequest) { (response, error) in
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
 **loginOneTimePasscodeRequest** | [**LoginOneTimePasscodeRequest**](LoginOneTimePasscodeRequest.md) | User Data | 

### Return type

[**OneTimePasscodeResponse**](OneTimePasscodeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginWebauthnFinish**
```swift
    open class func loginWebauthnFinish(appId: String, loginWebAuthnFinishRequest: LoginWebAuthnFinishRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Finish WebAuthn Login

Complete a WebAuthn login and authenticate the user. This endpoint accepts and verifies the response from `navigator.credential.get()` and returns an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let loginWebAuthnFinishRequest = LoginWebAuthnFinishRequest(handshakeId: "handshakeId_example", handshakeResponse: CredentialAssertionResponse(authenticatorAttachment: "authenticatorAttachment_example", clientExtensionResults: 123, id: "id_example", rawId: "rawId_example", response: CredentialAssertionResponse_response(authenticatorData: "authenticatorData_example", clientDataJSON: "clientDataJSON_example", signature: "signature_example", userHandle: "userHandle_example"), type: "type_example"), userId: "userId_example") // LoginWebAuthnFinishRequest | User Data

// Finish WebAuthn Login
LoginAPI.loginWebauthnFinish(appId: appId, loginWebAuthnFinishRequest: loginWebAuthnFinishRequest) { (response, error) in
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
 **loginWebAuthnFinishRequest** | [**LoginWebAuthnFinishRequest**](LoginWebAuthnFinishRequest.md) | User Data | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginWebauthnStart**
```swift
    open class func loginWebauthnStart(appId: String, loginWebAuthnStartRequest: LoginWebAuthnStartRequest? = nil, completion: @escaping (_ data: LoginWebAuthnStartResponse?, _ error: Error?) -> Void)
```

Start WebAuthn Login

Initiate a WebAuthn login for a user. This endpoint creates a WebAuthn credential assertion challenge that is used to perform the login ceremony from the browser.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let loginWebAuthnStartRequest = LoginWebAuthnStartRequest(identifier: "identifier_example") // LoginWebAuthnStartRequest | User Data (optional)

// Start WebAuthn Login
LoginAPI.loginWebauthnStart(appId: appId, loginWebAuthnStartRequest: loginWebAuthnStartRequest) { (response, error) in
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
 **loginWebAuthnStartRequest** | [**LoginWebAuthnStartRequest**](LoginWebAuthnStartRequest.md) | User Data | [optional] 

### Return type

[**LoginWebAuthnStartResponse**](LoginWebAuthnStartResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

