//
// CredentialCreationResponseResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CredentialCreationResponseResponse: Codable, JSONEncodable, Hashable {

    /** AttestationObject is the byte slice version of attestationObject. This attribute contains an attestation object, which is opaque to, and cryptographically protected against tampering by, the client. The attestation object contains both authenticator data and an attestation statement. The former contains the AAGUID, a unique credential ID, and the credential public key. The contents of the attestation statement are determined by the attestation statement format used by the authenticator. It also contains any additional information that the Relying Party's server requires to validate the attestation statement, as well as to decode and validate the authenticator data along with the JSON-serialized client data. */
    public var attestationObject: String?
    /** From the spec https://www.w3.org/TR/webauthn/#dom-authenticatorresponse-clientdatajson This attribute contains a JSON serialization of the client data passed to the authenticator by the client in its call to either create() or get(). */
    public var clientDataJSON: String?
    public var transports: [String]?

    public init(attestationObject: String? = nil, clientDataJSON: String? = nil, transports: [String]? = nil) {
        self.attestationObject = attestationObject
        self.clientDataJSON = clientDataJSON
        self.transports = transports
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case attestationObject
        case clientDataJSON
        case transports
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(attestationObject, forKey: .attestationObject)
        try container.encodeIfPresent(clientDataJSON, forKey: .clientDataJSON)
        try container.encodeIfPresent(transports, forKey: .transports)
    }
}
