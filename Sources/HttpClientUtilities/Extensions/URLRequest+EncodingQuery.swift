//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine

public extension URLRequest {
    
    func encodingQuery<P: Encodable, C: TopLevelEncoder>(_ parameters: P, coder: C) throws -> URLRequest where C.Output == String {
        let query = try coder.encode(parameters)
        if query.isEmpty {
            return self
        }
        guard let preparedURL = url?.appendingQuery(query) else {
            throw URLError(.badURL)
        }
        var request = self
        request.url = preparedURL
        return request
    }

    func encodingQuery<P: Encodable, C: TopLevelEncoder>(_ parameters: P, coder: C) throws -> URLRequest where C.Output == Data {
        let queryData = try coder.encode(parameters)
        if queryData.isEmpty {
            return self
        }
        let query = String(decoding: queryData, as: Unicode.ASCII.self)
        guard let preparedURL = url?.appendingQuery(query) else {
            throw URLError(.badURL)
        }
        var request = self
        request.url = preparedURL
        return request
    }
}
