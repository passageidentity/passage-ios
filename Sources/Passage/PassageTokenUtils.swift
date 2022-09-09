//
//  File.swift
//  
//
//  Created by blayne bayer on 9/1/22.
//

import Foundation



/// Some utils for Passage Tokens
///
/// Utils to decode and check if the token is expired
/// Can use the static methods or instantiate a new instance
public class PassageTokenUtils {
    
    
    /// The token to work with
    ///
    /// set when a new instance of the class is instantiated
    public var token: String;
    
    
    /// The decoded token
    ///
    /// when instantiating a new instance of the class with a token
    /// that token is automatically decoded and stored here
    public var decodedToken: [String: Any]

    public var expirationDate: Date {
        let timeInterval = self.decodedToken["exp"] as? TimeInterval
        let expirationDate = Date(timeIntervalSince1970: timeInterval!)
        return expirationDate
    }
    
    /// Whether the current token is expired or not
    public var isExpired : Bool {
        return PassageTokenUtils.isTokenExpired(decodedToken: self.decodedToken)
    }
    
    
    /// Create a new instance of the class with a token
    /// - Parameter token: The encoded token.
    public init(token: String) {
        self.token = token
        self.decodedToken = PassageTokenUtils.decode(jwtToken: token)
    }
    
    /// Decode the passed in token
    ///
    /// The token will be decoded into a Dictionary
    /// - Parameter jwt: The jwt token to decode
    /// - Returns: A dictionary of the decoded token.
    public static func decode(jwtToken jwt: String) -> [String: Any] {
      let segments = jwt.components(separatedBy: ".")
        return PassageTokenUtils.decodeJWTPart(segments[1]) ?? [:]
    }

    
    /// Check if a decoded token is expired
    /// - Parameter decodedToken: The decoded jwt token
    /// - Returns: `true if the token is expired, or false if not
    public static func isTokenExpired(decodedToken: [String: Any]) -> Bool {
        let timeInterval = decodedToken["exp"] as? TimeInterval
        let expirationDate = Date(timeIntervalSince1970: timeInterval!)
        let now = Date()
        return now > expirationDate
    }
    
    /// Check if a encoded token is expired
    /// - Parameter token: The encoded  jwt token
    /// - Returns: `true if the token is expired, or false if not
    public static func isTokenExpired(token: String) -> Bool {
        let decodedToken = PassageTokenUtils.decode(jwtToken: token)
        return PassageTokenUtils.isTokenExpired(decodedToken: decodedToken)
    }
    
    private static func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    private static func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = PassageTokenUtils.base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }
    
      return payload
    }

    // call like: decode(jwtToken: TOKEN)
    
    
}
