# CurrentuserAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteCurrentuserDevice**](CurrentuserAPI.md#deletecurrentuserdevice) | **DELETE** /apps/{app_id}/currentuser/devices/{device_id} | Revoke Device
[**deleteCurrentuserSocialConnection**](CurrentuserAPI.md#deletecurrentusersocialconnection) | **DELETE** /apps/{app_id}/currentuser/social-connections/{social_connection_type} | Delete Social Connection
[**getCurrentuser**](CurrentuserAPI.md#getcurrentuser) | **GET** /apps/{app_id}/currentuser | Get Current User
[**getCurrentuserDevices**](CurrentuserAPI.md#getcurrentuserdevices) | **GET** /apps/{app_id}/currentuser/devices | List Devices
[**getCurrentuserMetadata**](CurrentuserAPI.md#getcurrentusermetadata) | **GET** /apps/{app_id}/currentuser/user-metadata | Get user&#39;s metadata
[**getCurrentuserSocialConnections**](CurrentuserAPI.md#getcurrentusersocialconnections) | **GET** /apps/{app_id}/currentuser/social-connections | Get Social Connections
[**postCurrentuserAddDeviceFinish**](CurrentuserAPI.md#postcurrentuseradddevicefinish) | **POST** /apps/{app_id}/currentuser/devices/finish | Finish WebAuthn Add Device
[**postCurrentuserAddDeviceStart**](CurrentuserAPI.md#postcurrentuseradddevicestart) | **POST** /apps/{app_id}/currentuser/devices/start | Start WebAuthn Add Device
[**updateCurrentuserDevice**](CurrentuserAPI.md#updatecurrentuserdevice) | **PATCH** /apps/{app_id}/currentuser/devices/{device_id} | Update Device
[**updateCurrentuserMetadata**](CurrentuserAPI.md#updatecurrentusermetadata) | **PATCH** /apps/{app_id}/currentuser/user-metadata | Update user&#39;s metadata
[**updateEmailCurrentuser**](CurrentuserAPI.md#updateemailcurrentuser) | **PATCH** /apps/{app_id}/currentuser/email | Change Email
[**updatePhoneCurrentuser**](CurrentuserAPI.md#updatephonecurrentuser) | **PATCH** /apps/{app_id}/currentuser/phone | Change Phone


# **deleteCurrentuserDevice**
```swift
    open class func deleteCurrentuserDevice(appId: String, deviceId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Revoke Device

Revoke a device by ID for the current user. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let deviceId = "deviceId_example" // String | Device ID

// Revoke Device
CurrentuserAPI.deleteCurrentuserDevice(appId: appId, deviceId: deviceId) { (response, error) in
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
 **deviceId** | **String** | Device ID | 

### Return type

Void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCurrentuserSocialConnection**
```swift
    open class func deleteCurrentuserSocialConnection(appId: String, socialConnectionType: SocialConnectionType_deleteCurrentuserSocialConnection, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete Social Connection

Deletes a social connection for the current user. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let socialConnectionType = "socialConnectionType_example" // String | The type of social connection

// Delete Social Connection
CurrentuserAPI.deleteCurrentuserSocialConnection(appId: appId, socialConnectionType: socialConnectionType) { (response, error) in
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
 **socialConnectionType** | **String** | The type of social connection | 

### Return type

Void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentuser**
```swift
    open class func getCurrentuser(appId: String, completion: @escaping (_ data: CurrentUserResponse?, _ error: Error?) -> Void)
```

Get Current User

Get information about a user that is currently authenticated via bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get Current User
CurrentuserAPI.getCurrentuser(appId: appId) { (response, error) in
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

[**CurrentUserResponse**](CurrentUserResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentuserDevices**
```swift
    open class func getCurrentuserDevices(appId: String, completion: @escaping (_ data: CurrentUserDevices?, _ error: Error?) -> Void)
```

List Devices

List all WebAuthn devices for the authenticated user. User must be authenticated via bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// List Devices
CurrentuserAPI.getCurrentuserDevices(appId: appId) { (response, error) in
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

[**CurrentUserDevices**](CurrentUserDevices.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentuserMetadata**
```swift
    open class func getCurrentuserMetadata(appId: String, completion: @escaping (_ data: UserMetadataResponse?, _ error: Error?) -> Void)
```

Get user's metadata

Get the user-metadata for the current user.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get user's metadata
CurrentuserAPI.getCurrentuserMetadata(appId: appId) { (response, error) in
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

[**UserMetadataResponse**](UserMetadataResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentuserSocialConnections**
```swift
    open class func getCurrentuserSocialConnections(appId: String, completion: @escaping (_ data: SocialConnectionsResponse?, _ error: Error?) -> Void)
```

Get Social Connections

Gets social connections for the current user. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID

// Get Social Connections
CurrentuserAPI.getCurrentuserSocialConnections(appId: appId) { (response, error) in
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

[**SocialConnectionsResponse**](SocialConnectionsResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postCurrentuserAddDeviceFinish**
```swift
    open class func postCurrentuserAddDeviceFinish(appId: String, addDeviceFinishRequest: AddDeviceFinishRequest, completion: @escaping (_ data: CurrentUserDevice?, _ error: Error?) -> Void)
```

Finish WebAuthn Add Device

Complete a WebAuthn add device operation for the current user. This endpoint accepts and verifies the response from `navigator.credential.create()` and returns the created device for the user. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let addDeviceFinishRequest = AddDeviceFinishRequest(handshakeId: "handshakeId_example", handshakeResponse: CredentialCreationResponse(authenticatorAttachment: "authenticatorAttachment_example", clientExtensionResults: 123, id: "id_example", rawId: "rawId_example", response: CredentialCreationResponse_response(attestationObject: "attestationObject_example", clientDataJSON: "clientDataJSON_example", transports: ["transports_example"]), transports: ["transports_example"], type: "type_example"), userId: "userId_example") // AddDeviceFinishRequest | WebAuthn Response Data

// Finish WebAuthn Add Device
CurrentuserAPI.postCurrentuserAddDeviceFinish(appId: appId, addDeviceFinishRequest: addDeviceFinishRequest) { (response, error) in
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
 **addDeviceFinishRequest** | [**AddDeviceFinishRequest**](AddDeviceFinishRequest.md) | WebAuthn Response Data | 

### Return type

[**CurrentUserDevice**](CurrentUserDevice.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postCurrentuserAddDeviceStart**
```swift
    open class func postCurrentuserAddDeviceStart(appId: String, currentUserDevicesStartRequest: CurrentUserDevicesStartRequest? = nil, completion: @escaping (_ data: AddDeviceStartResponse?, _ error: Error?) -> Void)
```

Start WebAuthn Add Device

Initiate a WebAuthn add device operation for the current user. This endpoint creates a WebAuthn credential creation challenge that is used to perform the registration ceremony from the browser. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let currentUserDevicesStartRequest = CurrentUserDevicesStartRequest(authenticatorAttachment: AuthenticatorAttachment()) // CurrentUserDevicesStartRequest | WebAuthn Start Response Data (optional)

// Start WebAuthn Add Device
CurrentuserAPI.postCurrentuserAddDeviceStart(appId: appId, currentUserDevicesStartRequest: currentUserDevicesStartRequest) { (response, error) in
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
 **currentUserDevicesStartRequest** | [**CurrentUserDevicesStartRequest**](CurrentUserDevicesStartRequest.md) | WebAuthn Start Response Data | [optional] 

### Return type

[**AddDeviceStartResponse**](AddDeviceStartResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCurrentuserDevice**
```swift
    open class func updateCurrentuserDevice(appId: String, deviceId: String, updateDeviceRequest: UpdateDeviceRequest, completion: @escaping (_ data: CurrentUserDevice?, _ error: Error?) -> Void)
```

Update Device

Update a device by ID for the current user. Currently the only field that can be updated is the friendly name. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let deviceId = "deviceId_example" // String | Device ID
let updateDeviceRequest = UpdateDeviceRequest(friendlyName: "friendlyName_example") // UpdateDeviceRequest | Friendly Name

// Update Device
CurrentuserAPI.updateCurrentuserDevice(appId: appId, deviceId: deviceId, updateDeviceRequest: updateDeviceRequest) { (response, error) in
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
 **deviceId** | **String** | Device ID | 
 **updateDeviceRequest** | [**UpdateDeviceRequest**](UpdateDeviceRequest.md) | Friendly Name | 

### Return type

[**CurrentUserDevice**](CurrentUserDevice.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCurrentuserMetadata**
```swift
    open class func updateCurrentuserMetadata(appId: String, updateMetadataRequest: UpdateMetadataRequest, completion: @escaping (_ data: CurrentUserResponse?, _ error: Error?) -> Void)
```

Update user's metadata

Update the metadata for the current user. Only valid metadata fields are accepted. Invalid metadata fields that are present will abort the update. User must be authenticated via a bearer token.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let updateMetadataRequest = UpdateMetadataRequest(userMetadata: 123) // UpdateMetadataRequest | User Metadata

// Update user's metadata
CurrentuserAPI.updateCurrentuserMetadata(appId: appId, updateMetadataRequest: updateMetadataRequest) { (response, error) in
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
 **updateMetadataRequest** | [**UpdateMetadataRequest**](UpdateMetadataRequest.md) | User Metadata | 

### Return type

[**CurrentUserResponse**](CurrentUserResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEmailCurrentuser**
```swift
    open class func updateEmailCurrentuser(appId: String, updateUserEmailRequest: UpdateUserEmailRequest, completion: @escaping (_ data: MagicLinkResponse?, _ error: Error?) -> Void)
```

Change Email

Initiate an email change for the authenticated user. An email change requires verification, so an email will be sent to the user which they must verify before the email change takes effect.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let updateUserEmailRequest = UpdateUserEmailRequest(language: "language_example", magicLinkPath: "magicLinkPath_example", newEmail: "newEmail_example", redirectUrl: "redirectUrl_example") // UpdateUserEmailRequest | email

// Change Email
CurrentuserAPI.updateEmailCurrentuser(appId: appId, updateUserEmailRequest: updateUserEmailRequest) { (response, error) in
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
 **updateUserEmailRequest** | [**UpdateUserEmailRequest**](UpdateUserEmailRequest.md) | email | 

### Return type

[**MagicLinkResponse**](MagicLinkResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePhoneCurrentuser**
```swift
    open class func updatePhoneCurrentuser(appId: String, updateUserPhoneRequest: UpdateUserPhoneRequest, completion: @escaping (_ data: MagicLinkResponse?, _ error: Error?) -> Void)
```

Change Phone

Initiate a phone number change for the authenticated user. An phone number change requires verification, so an SMS with a link will be sent to the user which they must verify before the phone number change takes effect.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let updateUserPhoneRequest = UpdateUserPhoneRequest(language: "language_example", magicLinkPath: "magicLinkPath_example", newPhone: "newPhone_example", redirectUrl: "redirectUrl_example") // UpdateUserPhoneRequest | phone

// Change Phone
CurrentuserAPI.updatePhoneCurrentuser(appId: appId, updateUserPhoneRequest: updateUserPhoneRequest) { (response, error) in
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
 **updateUserPhoneRequest** | [**UpdateUserPhoneRequest**](UpdateUserPhoneRequest.md) | phone | 

### Return type

[**MagicLinkResponse**](MagicLinkResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

