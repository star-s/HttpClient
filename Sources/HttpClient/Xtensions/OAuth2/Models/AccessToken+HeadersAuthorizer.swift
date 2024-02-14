//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public extension HeadersAuthorizer where Self: AccessToken {
    func authorize(headers: HTTPHeaders) async throws -> HTTPHeaders {
        guard tokenType == .bearer else {
            return headers
        }
        var headers = headers
        headers.add(.authorization(bearerToken: accessToken))
        return headers
    }
}
