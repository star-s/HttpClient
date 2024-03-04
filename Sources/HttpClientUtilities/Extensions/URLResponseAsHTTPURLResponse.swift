//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public extension URLResponse {
    
    enum Error: Swift.Error {
        case notHttpResponse
    }

    @inlinable
    func asHTTPURLResponse() throws -> HTTPURLResponse {
        guard let httpResponse = self as? HTTPURLResponse else {
            throw Error.notHttpResponse
        }
        return httpResponse
    }
}
