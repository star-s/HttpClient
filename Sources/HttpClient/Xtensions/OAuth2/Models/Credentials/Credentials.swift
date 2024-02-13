//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public protocol Credentials {
    func authorize(headers: HTTPHeaders) throws -> HTTPHeaders
}

public extension Credentials where Self: AccessToken {
    func authorize(headers: HTTPHeaders) throws -> HTTPHeaders {
        guard tokenType == .bearer else {
            return headers
        }
        var headers = headers
        headers.add(.authorization(bearerToken: accessToken))
        return headers
    }
}
