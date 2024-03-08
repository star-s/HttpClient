//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 13.02.2024.
//

import Foundation
import HttpClientUtilities

public extension RequestAuthorizer where Self: AccessToken {
    func authorizer(request: URLRequest) async throws -> URLRequest {
        guard tokenType == .bearer else {
            return request
        }
        var request = request
        request.headers.add(.authorization(bearerToken: accessToken))
        return request
    }
}
