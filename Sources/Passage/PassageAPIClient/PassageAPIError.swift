//
//  PassageAPIError.swift
//  Shiny
//
//  Created by blayne bayer on 8/30/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation

public struct PassageErrorResponseBody : Codable {
    var status: String?
    var code: String?
    var error: String?
    var errors: [String:String]?
}

public struct PassageAPIErrorResponse: Codable {
    let code: Int
    let message: String
    let body: PassageErrorResponseBody?
}

public enum PassageAPIError: Error {
    case failedResponse(PassageAPIErrorResponse)
    case unauthorized(PassageAPIErrorResponse)
    case notFound(PassageAPIErrorResponse)
    case malformedUrl
    case internalServerError(PassageAPIErrorResponse)
    case badRequest(PassageAPIErrorResponse)
    case conflict(PassageAPIErrorResponse)

}
