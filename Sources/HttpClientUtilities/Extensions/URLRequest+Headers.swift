//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public extension URLRequest {
    
    func settingMethod(_ method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }
    
    func settingHeaders(_ headers: HTTPHeaders = .default) -> URLRequest {
        var request = self
        request.headers = headers
        return request
    }
    
    func appendingHeader(_ header: HTTPHeader) -> URLRequest {
        var request = self
        request.headers.add(header)
        return request
    }
}
