//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.03.2024.
//

import Foundation

public protocol RequestAuthorizer {
    func authorizer(request: URLRequest) async throws -> URLRequest
}

public extension URLRequest {
    @inlinable
    func authorize(with authorizer: RequestAuthorizer?) async throws -> URLRequest {
        guard let authorizer else {
            return self
        }
        return try await authorizer.authorizer(request: self)
    }
}
