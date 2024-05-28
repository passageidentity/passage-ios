# AuthenticateAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authenticateWebauthnFinishWithTransaction**](AuthenticateAPI.md#authenticatewebauthnfinishwithtransaction) | **POST** /apps/{app_id}/authenticate/transactions/webauthn/finish | Finish WebAuthn authentication with an optional transaction
[**authenticateWebauthnStartWithTransaction**](AuthenticateAPI.md#authenticatewebauthnstartwithtransaction) | **POST** /apps/{app_id}/authenticate/transactions/webauthn/start | Start WebAuthn authentication with an optional transaction


# **authenticateWebauthnFinishWithTransaction**
```swift
    open class func authenticateWebauthnFinishWithTransaction(appId: String, authenticateWebAuthnFinishWithTransactionRequest: AuthenticateWebAuthnFinishWithTransactionRequest, completion: @escaping (_ data: Nonce?, _ error: Error?) -> Void)
```

Finish WebAuthn authentication with an optional transaction

Complete a WebAuthn authentication and authenticate the user via a transaction. This endpoint accepts and verifies the response from `navigator.credential.get()` and returns a nonce meant to be exchanged for an authentication token for the user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let authenticateWebAuthnFinishWithTransactionRequest = AuthenticateWebAuthnFinishWithTransactionRequest(handshakeId: "handshakeId_example", handshakeResponse: CredentialAssertionResponse(authenticatorAttachment: "authenticatorAttachment_example", clientExtensionResults: 123, id: "id_example", rawId: "rawId_example", response: CredentialAssertionResponse_response(authenticatorData: "authenticatorData_example", clientDataJSON: "clientDataJSON_example", signature: "signature_example", userHandle: "userHandle_example"), type: "type_example"), transactionId: "transactionId_example") // AuthenticateWebAuthnFinishWithTransactionRequest | 

// Finish WebAuthn authentication with an optional transaction
AuthenticateAPI.authenticateWebauthnFinishWithTransaction(appId: appId, authenticateWebAuthnFinishWithTransactionRequest: authenticateWebAuthnFinishWithTransactionRequest) { (response, error) in
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
 **authenticateWebAuthnFinishWithTransactionRequest** | [**AuthenticateWebAuthnFinishWithTransactionRequest**](AuthenticateWebAuthnFinishWithTransactionRequest.md) |  | 

### Return type

[**Nonce**](Nonce.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authenticateWebauthnStartWithTransaction**
```swift
    open class func authenticateWebauthnStartWithTransaction(appId: String, authenticateWebAuthnStartWithTransactionRequest: AuthenticateWebAuthnStartWithTransactionRequest? = nil, completion: @escaping (_ data: AuthenticateWebAuthnStartWithTransactionResponse?, _ error: Error?) -> Void)
```

Start WebAuthn authentication with an optional transaction

Initiate a WebAuthn authentication for a user via a transaction. This endpoint creates a WebAuthn credential assertion challenge that is used to perform the authentication ceremony from the browser.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let authenticateWebAuthnStartWithTransactionRequest = AuthenticateWebAuthnStartWithTransactionRequest(transactionId: "transactionId_example") // AuthenticateWebAuthnStartWithTransactionRequest |  (optional)

// Start WebAuthn authentication with an optional transaction
AuthenticateAPI.authenticateWebauthnStartWithTransaction(appId: appId, authenticateWebAuthnStartWithTransactionRequest: authenticateWebAuthnStartWithTransactionRequest) { (response, error) in
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
 **authenticateWebAuthnStartWithTransactionRequest** | [**AuthenticateWebAuthnStartWithTransactionRequest**](AuthenticateWebAuthnStartWithTransactionRequest.md) |  | [optional] 

### Return type

[**AuthenticateWebAuthnStartWithTransactionResponse**](AuthenticateWebAuthnStartWithTransactionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

