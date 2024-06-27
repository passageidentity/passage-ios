# CredentialCreationPublicKeyUser

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**displayName** | **String** | A human-palatable name for the user account, intended only for display. For example, \&quot;Alex P. Müller\&quot; or \&quot;田中 倫\&quot;. The Relying Party SHOULD let the user choose this, and SHOULD NOT restrict the choice more than necessary. | [optional] 
**icon** | **String** | A serialized URL which resolves to an image associated with the entity. For example, this could be a user’s avatar or a Relying Party&#39;s logo. This URL MUST be an a priori authenticated URL. Authenticators MUST accept and store a 128-byte minimum length for an icon member’s value. Authenticators MAY ignore an icon member’s value if its length is greater than 128 bytes. The URL’s scheme MAY be \&quot;data\&quot; to avoid fetches of the URL, at the cost of needing more storage.  Deprecated: this has been removed from the specification recommendations. | [optional] 
**id** | **String** | ID is the user handle of the user account entity. To ensure secure operation, authentication and authorization decisions MUST be made on the basis of this id member, not the displayName nor name members. See Section 6.1 of [RFC8266](https://www.w3.org/TR/webauthn/#biblio-rfc8266). | [optional] 
**name** | **String** | A human-palatable name for the entity. Its function depends on what the PublicKeyCredentialEntity represents:  When inherited by PublicKeyCredentialRpEntity it is a human-palatable identifier for the Relying Party, intended only for display. For example, \&quot;ACME Corporation\&quot;, \&quot;Wonderful Widgets, Inc.\&quot; or \&quot;ОАО Примертех\&quot;.  When inherited by PublicKeyCredentialUserEntity, it is a human-palatable identifier for a user account. It is intended only for display, i.e., aiding the user in determining the difference between user accounts with similar displayNames. For example, \&quot;alexm\&quot;, \&quot;alex.p.mueller@example.com\&quot; or \&quot;+14255551234\&quot;. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


