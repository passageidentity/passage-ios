# UsersAPI

All URIs are relative to *https://auth.passage.id/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**checkUserIdentifier**](UsersAPI.md#checkuseridentifier) | **GET** /apps/{app_id}/users | Get User
[**createUser**](UsersAPI.md#createuser) | **POST** /apps/{app_id}/users | Create User


# **checkUserIdentifier**
```swift
    open class func checkUserIdentifier(appId: String, identifier: String, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Get User

Get user information, if the user exists. This endpoint can be used to determine whether a user has an existing account and if they should login or register.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let identifier = "identifier_example" // String | email or phone number

// Get User
UsersAPI.checkUserIdentifier(appId: appId, identifier: identifier) { (response, error) in
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
 **identifier** | **String** | email or phone number | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createUser**
```swift
    open class func createUser(appId: String, createUserParams: CreateUserParams, completion: @escaping (_ data: UserResponse?, _ error: Error?) -> Void)
```

Create User

Create a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let appId = "appId_example" // String | App ID
let createUserParams = CreateUserParams(identifier: "identifier_example", userMetadata: 123) // CreateUserParams | user options

// Create User
UsersAPI.createUser(appId: appId, createUserParams: createUserParams) { (response, error) in
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
 **createUserParams** | [**CreateUserParams**](CreateUserParams.md) | user options | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

