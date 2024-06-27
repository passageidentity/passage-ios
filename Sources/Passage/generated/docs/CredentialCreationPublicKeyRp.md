# CredentialCreationPublicKeyRp

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**icon** | **String** | A serialized URL which resolves to an image associated with the entity. For example, this could be a user’s avatar or a Relying Party&#39;s logo. This URL MUST be an a priori authenticated URL. Authenticators MUST accept and store a 128-byte minimum length for an icon member’s value. Authenticators MAY ignore an icon member’s value if its length is greater than 128 bytes. The URL’s scheme MAY be \&quot;data\&quot; to avoid fetches of the URL, at the cost of needing more storage.  Deprecated: this has been removed from the specification recommendations. | [optional] 
**id** | **String** | A unique identifier for the Relying Party entity, which sets the RP ID. | [optional] 
**name** | **String** | A human-palatable name for the entity. Its function depends on what the PublicKeyCredentialEntity represents:  When inherited by PublicKeyCredentialRpEntity it is a human-palatable identifier for the Relying Party, intended only for display. For example, \&quot;ACME Corporation\&quot;, \&quot;Wonderful Widgets, Inc.\&quot; or \&quot;ОАО Примертех\&quot;.  When inherited by PublicKeyCredentialUserEntity, it is a human-palatable identifier for a user account. It is intended only for display, i.e., aiding the user in determining the difference between user accounts with similar displayNames. For example, \&quot;alexm\&quot;, \&quot;alex.p.mueller@example.com\&quot; or \&quot;+14255551234\&quot;. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


