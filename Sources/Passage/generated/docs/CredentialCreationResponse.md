# CredentialCreationResponse

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**authenticatorAttachment** | **String** |  | [optional] 
**clientExtensionResults** | **AnyCodable** |  | [optional] 
**id** | **String** | ID is The credential&#39;s identifier. The requirements for the identifier are distinct for each type of credential. It might represent a username for username/password tuples, for example. | [optional] 
**rawId** | **String** |  | [optional] 
**response** | [**CredentialCreationResponseResponse**](CredentialCreationResponseResponse.md) |  | [optional] 
**transports** | **[String]** |  | [optional] 
**type** | **String** | Type is the value of the object&#39;s interface object&#39;s [[type]] slot, which specifies the credential type represented by this object. This should be type \&quot;public-key\&quot; for Webauthn credentials. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


