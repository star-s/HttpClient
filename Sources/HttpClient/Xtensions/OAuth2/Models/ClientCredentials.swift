//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public struct ClientCredentials {
    public let clientId: String
    private let clientSecret: String

    public init(id: String, secret: String) {
        clientId = id
        clientSecret = secret
    }
}

extension ClientCredentials: Codable {
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}

extension ClientCredentials: HeadersAuthorizer {
    public func authorize(headers: HTTPHeaders) async throws -> HTTPHeaders {
        var headers = headers
        headers.add(.authorization(username: clientId, password: clientSecret))
        return headers
    }
}
