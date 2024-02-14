//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public extension URLRequest {
    
    @inlinable
    func with(method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }
    
    @inlinable
    func with(headers: HTTPHeaders) -> URLRequest {
        var request = self
        request.headers = headers
        return request
    }
    
    @inlinable
    func withAdded(header: HTTPHeader) -> URLRequest {
        var request = self
        request.headers.add(header)
        return request
    }
}
