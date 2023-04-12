import Foundation
import os

enum URLError: Error {
    case Malformed(String)
}

internal struct ListMessagesResponse: Codable {
    public var items: [ListMessage]
}

internal struct ListMessage : Codable {
    public var id: String
    public var received: String
    public var type: String
    public var subject: String
    public var from: [NameEmail]
    public var to: [NameEmail]
    public var cc: [String]
    public var bcc: [String]
}

internal struct NameEmail: Codable {
    public var name: String
    public var email: String
}

internal struct GetMessageResponse: Codable {
    public var id: String
    public var received: String
    public var type: String
    public var subject: String
    public var from: [NameEmail]
    public var to: [NameEmail]
    public var cc: [String]
    public var bcc: [String]
    public var html: MessageHTML
}

internal struct MessageHTML: Codable {
    public var body: String
    public var links: [MessageLink]
    public var codes: [MessageCode]
}

internal struct MessageLink: Codable {
    public var href: String
    public var text: String
}

internal struct MessageCode: Codable {
    public var value: String
}

internal class MailosaurAPIClient {
    // note: this is public information
    internal static let serverId = "ncor7c1m"
    
    private var apiURL = "https://mailosaur.com/api/messages"
    
    private func appUrl(_ path: String) throws -> URL {
        guard let url = URL(string: apiURL + path) else {
            throw URLError.Malformed("Bad url path")
        }
        return url
    }
    
    private var authHeader: String {
        let apiKey = "api:\(mailosaurAPIKey)".data(using: .utf8)?.base64EncodedString()
        return "Basic: \(apiKey!)"
    }
    
    func getMostRecentMagicLink() async throws -> String {
        do{
            let messages = try await listMessages()
            guard !messages.isEmpty else { return "" }
            let message = try await getMessage(id: messages[0].id)
            let incomingURL = message.html.links[0].href
            let components = NSURLComponents(url: URL(string: incomingURL)!, resolvingAgainstBaseURL: true)
            guard let magicLink = components!.queryItems?.filter({$0.name == "psg_magic_link"}).first?.value else {
                return ""
            }
            return magicLink
        } catch {
            print(error)
            return ""
        }
    }
    
    func getMostRecentOneTimePasscode() async throws -> String {
        do{
            let messages = try await listMessages()
            guard !messages.isEmpty else { return "" }
            let message = try await getMessage(id: messages[0].id)
            let oneTimePasscode = message.html.codes.isEmpty ? "" : message.html.codes[0].value
            return oneTimePasscode
        } catch {
            print(error)
            return ""
        }
    }
    
    func getMessage(id: String) async throws -> GetMessageResponse {
        let url = try appUrl("/" + id)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)

        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let (responseData, _ ) = try await URLSession.shared.data(for: request)
        let message = try JSONDecoder().decode(GetMessageResponse.self, from: responseData)
        return message
    }
    
    func listMessages() async throws -> [ListMessage] {
        do {
            let url = try appUrl("?server=" + MailosaurAPIClient.serverId)
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)

            request.addValue(authHeader, forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "GET"
            
            let (responseData, _ ) = try await URLSession.shared.data(for: request)
            let messages = try JSONDecoder().decode(ListMessagesResponse.self, from: responseData)
            return messages.items
        } catch {
            print(error)
            return []
        }
    }
}
