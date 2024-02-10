//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.02.2024.
//

import Foundation

public typealias JsonRpcRequestEncoder = JsonRequestEncoder

public struct JsonRpcResponseDecoder: ResponseDecoder {
    private let decoder: JSONDecoder

    public init(_ decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {}

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        try decoder.decode(JsonRpcResponse<T>.self, from: response.data).result.get()
    }
}
