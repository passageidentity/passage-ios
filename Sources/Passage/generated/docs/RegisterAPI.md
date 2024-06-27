# RegisterAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**registerMagicLink**](RegisterAPI.md#registermagiclink) | **POST** /apps/{app_id}/register/magic-link | Register with Magic Link
[**registerOneTimePasscode**](RegisterAPI.md#registeronetimepasscode) | **POST** /apps/{app_id}/register/otp | Register with OTP
[**registerWebauthnFinish**](RegisterAPI.md#registerwebauthnfinish) | **POST** /apps/{app_id}/register/webauthn/finish | Finish WebAuthn Registration
[**registerWebauthnFinishWithTransaction**](RegisterAPI.md#registerwebauthnfinishwithtransaction) | **POST** /apps/{app_id}/register/transactions/webauthn/finish | Finish WebAuthn registration with a transaction
[**registerWebauthnStart**](RegisterAPI.md#registerwebauthnstart) | **POST** /apps/{app_id}/register/webauthn/start | Start WebAuthn Register
[**registerWebauthnStartWithTransaction**](RegisterAPI.md#registerwebauthnstartwithtransaction) | **POST** /apps/{app_id}/register/transactions/webauthn/start | Start WebAuthn registration with a transaction


# **registerMagicLink**
```swift
    open class func registerMagicLink(appId: String, user: RegisterMagicLinkRequest, completion: @escaping (_ data: RegisterMagicLinkResponse?, _ error: Error?) -> Void)
```

Register with Magic Link

Create a user and send an registration email or SMS to the user. The user will receive an email or text with a link to complete their registration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let user = RegisterMagicLinkRequest(identifier: "identifier_example", language: "language_example", magicLinkPath: "magicLinkPath_example") // RegisterMagicLinkRequest | User Data

// Register with Magic Link
RegisterAPI.registerMagicLink(appId: appId, user: user) { (response, error) in
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
 **user** | [**RegisterMagicLinkRequest**](RegisterMagicLinkRequest.md) | User Data | 

### Return type

[**RegisterMagicLinkResponse**](RegisterMagicLinkResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerOneTimePasscode**
```swift
    open class func registerOneTimePasscode(appId: String, registerOneTimePasscodeRequest: RegisterOneTimePasscodeRequest, completion: @escaping (_ data: OneTimePasscodeResponse?, _ error: Error?) -> Void)
```

Register with OTP

Create a user and send a registration email or SMS to the user. The user will receive an email or text with a one-time passcode to complete their registration.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let registerOneTimePasscodeRequest = RegisterOneTimePasscodeRequest(identifier: "identifier_example", language: "language_example") // RegisterOneTimePasscodeRequest | User Data

// Register with OTP
RegisterAPI.registerOneTimePasscode(appId: appId, registerOneTimePasscodeRequest: registerOneTimePasscodeRequest) { (response, error) in
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
 **registerOneTimePasscodeRequest** | [**RegisterOneTimePasscodeRequest**](RegisterOneTimePasscodeRequest.md) | User Data | 

### Return type

[**OneTimePasscodeResponse**](OneTimePasscodeResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerWebauthnFinish**
```swift
    open class func registerWebauthnFinish(appId: String, registerWebAuthnFinishRequest: RegisterWebAuthnFinishRequest, completion: @escaping (_ data: AuthResponse?, _ error: Error?) -> Void)
```

Finish WebAuthn Registration

Complete a WebAuthn registration and authenticate the user. This endpoint accepts and verifies the response from `navigator.credential.create()` and returns an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let registerWebAuthnFinishRequest = RegisterWebAuthnFinishRequest(handshakeId: "handshakeId_example", handshakeResponse: CredentialCreationResponse(authenticatorAttachment: "authenticatorAttachment_example", clientExtensionResults: 123, id: "id_example", rawId: "rawId_example", response: CredentialCreationResponse_response(attestationObject: "attestationObject_example", clientDataJSON: "clientDataJSON_example", transports: ["transports_example"]), transports: ["transports_example"], type: "type_example"), userId: "userId_example") // RegisterWebAuthnFinishRequest | WebAuthn Response Data

// Finish WebAuthn Registration
RegisterAPI.registerWebauthnFinish(appId: appId, registerWebAuthnFinishRequest: registerWebAuthnFinishRequest) { (response, error) in
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
 **registerWebAuthnFinishRequest** | [**RegisterWebAuthnFinishRequest**](RegisterWebAuthnFinishRequest.md) | WebAuthn Response Data | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerWebauthnFinishWithTransaction**
```swift
    open class func registerWebauthnFinishWithTransaction(appId: String, registerWebAuthnFinishWithTransactionRequest: RegisterWebAuthnFinishWithTransactionRequest, completion: @escaping (_ data: Nonce?, _ error: Error?) -> Void)
```

Finish WebAuthn registration with a transaction

Complete a WebAuthn registration and authenticate the user via a transaction. This endpoint accepts and verifies the response from `navigator.credential.create()` and returns a nonce meant to be exchanged for an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let registerWebAuthnFinishWithTransactionRequest = RegisterWebAuthnFinishWithTransactionRequest(handshakeId: "handshakeId_example", handshakeResponse: CredentialCreationResponse(authenticatorAttachment: "authenticatorAttachment_example", clientExtensionResults: 123, id: "id_example", rawId: "rawId_example", response: CredentialCreationResponse_response(attestationObject: "attestationObject_example", clientDataJSON: "clientDataJSON_example", transports: ["transports_example"]), transports: ["transports_example"], type: "type_example"), transactionId: "transactionId_example") // RegisterWebAuthnFinishWithTransactionRequest | 

// Finish WebAuthn registration with a transaction
RegisterAPI.registerWebauthnFinishWithTransaction(appId: appId, registerWebAuthnFinishWithTransactionRequest: registerWebAuthnFinishWithTransactionRequest) { (response, error) in
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
 **registerWebAuthnFinishWithTransactionRequest** | [**RegisterWebAuthnFinishWithTransactionRequest**](RegisterWebAuthnFinishWithTransactionRequest.md) |  | 

### Return type

[**Nonce**](Nonce.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerWebauthnStart**
```swift
    open class func registerWebauthnStart(appId: String, registerWebAuthnStartRequest: RegisterWebAuthnStartRequest, completion: @escaping (_ data: RegisterWebAuthnStartResponse?, _ error: Error?) -> Void)
```

Start WebAuthn Register

Initiate a WebAuthn registration and create the user. This endpoint creates a WebAuthn credential creation challenge that is used to perform the registration ceremony from the browser.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let registerWebAuthnStartRequest = RegisterWebAuthnStartRequest(identifier: "identifier_example", authenticatorAttachment: AuthenticatorAttachment()) // RegisterWebAuthnStartRequest | User Data

// Start WebAuthn Register
RegisterAPI.registerWebauthnStart(appId: appId, registerWebAuthnStartRequest: registerWebAuthnStartRequest) { (response, error) in
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
 **registerWebAuthnStartRequest** | [**RegisterWebAuthnStartRequest**](RegisterWebAuthnStartRequest.md) | User Data | 

### Return type

[**RegisterWebAuthnStartResponse**](RegisterWebAuthnStartResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerWebauthnStartWithTransaction**
```swift
    open class func registerWebauthnStartWithTransaction(appId: String, registerWebAuthnStartWithTransactionRequest: RegisterWebAuthnStartWithTransactionRequest, completion: @escaping (_ data: RegisterWebAuthnStartWithTransactionResponse?, _ error: Error?) -> Void)
```

Start WebAuthn registration with a transaction

Initiate a WebAuthn registration and create the user via a transaction. This endpoint creates a WebAuthn credential creation challenge that is used to perform the registration ceremony from the browser.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let registerWebAuthnStartWithTransactionRequest = RegisterWebAuthnStartWithTransactionRequest(transactionId: "transactionId_example", authenticatorAttachment: AuthenticatorAttachment()) // RegisterWebAuthnStartWithTransactionRequest | 

// Start WebAuthn registration with a transaction
RegisterAPI.registerWebauthnStartWithTransaction(appId: appId, registerWebAuthnStartWithTransactionRequest: registerWebAuthnStartWithTransactionRequest) { (response, error) in
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
 **registerWebAuthnStartWithTransactionRequest** | [**RegisterWebAuthnStartWithTransactionRequest**](RegisterWebAuthnStartWithTransactionRequest.md) |  | 

### Return type

[**RegisterWebAuthnStartWithTransactionResponse**](RegisterWebAuthnStartWithTransactionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

