# CredentialCreationResponseResponse

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**attestationObject** | **String** | AttestationObject is the byte slice version of attestationObject. This attribute contains an attestation object, which is opaque to, and cryptographically protected against tampering by, the client. The attestation object contains both authenticator data and an attestation statement. The former contains the AAGUID, a unique credential ID, and the credential public key. The contents of the attestation statement are determined by the attestation statement format used by the authenticator. It also contains any additional information that the Relying Party&#39;s server requires to validate the attestation statement, as well as to decode and validate the authenticator data along with the JSON-serialized client data. | [optional] 
**clientDataJSON** | **String** | From the spec https://www.w3.org/TR/webauthn/#dom-authenticatorresponse-clientdatajson This attribute contains a JSON serialization of the client data passed to the authenticator by the client in its call to either create() or get(). | [optional] 
**transports** | **[String]** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


