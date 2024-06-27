# CurrentUser

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**createdAt** | **String** | When this user was created | 
**email** | **String** | The user&#39;s email | 
**emailVerified** | **Bool** | Whether or not the user&#39;s email has been verified | 
**id** | **String** | The user ID | 
**lastLoginAt** | **String** | The last time this user logged in | 
**loginCount** | **Int** | How many times the user has successfully logged in | 
**phone** | **String** | The user&#39;s phone | 
**phoneVerified** | **Bool** | Whether or not the user&#39;s phone has been verified | 
**socialConnections** | [**UserSocialConnections**](UserSocialConnections.md) |  | 
**status** | [**UserStatus**](UserStatus.md) |  | 
**updatedAt** | **String** | When this user was last updated | 
**userMetadata** | **AnyCodable** |  | 
**webauthn** | **Bool** | Whether or not the user has authenticated via webAuthn before (if len(WebAuthnDevices) &gt; 0) | 
**webauthnDevices** | [Credential] | The list of devices this user has authenticated with via webAuthn | 
**webauthnTypes** | [WebAuthnType] | List of credential types that user has created | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


