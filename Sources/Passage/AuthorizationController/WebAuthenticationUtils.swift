import CommonCrypto
import Foundation

internal struct WebAuthenticationUtils {
    
    internal static func getRandomString(length: Int) -> String {
        let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString = ""
        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(UInt32(characters.count)))
            randomString += String(
                characters[
                    characters.index(characters.startIndex, offsetBy: randomValue)
                ]
            )
        }
        return randomString
    }
    
    internal static func sha256Hash(_ str: String) -> String {
        let data = Data(str.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        let base64EncodedString = Data(hash).base64EncodedString()
        let base64URL = base64EncodedString
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64URL
    }
    
}
