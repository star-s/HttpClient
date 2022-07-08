//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public extension URLRequest {
    
    func with(method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }
    
    func with(headers: HTTPHeaders) -> URLRequest {
        var request = self
        request.headers = headers
        return request
    }
    
    func withAdded(header: HTTPHeader) -> URLRequest {
        var request = self
        request.headers.add(header)
        return request
    }
}
