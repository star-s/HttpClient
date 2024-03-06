//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 10.02.2024.
//

import Foundation

public typealias JsonRpcRequestEncoder = JsonRequestEncoder

public struct JsonRpcResponseDecoder: ResponseDecoder {
    private let validator: ((URLResponse) async throws -> Void)?
    private let decoder: JSONDecoder

    public init(
        _ decoder: JSONDecoder = JSONDecoder(),
        validator: ((URLResponse) async throws -> Void)? = nil
    ) {
        self.validator = validator
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        guard let validator else {
            return
        }
        try await validator(response.response)
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        if T.self is [JsonRpcResponse<AnyDecodable>].Type {
            return try decoder.decode(T.self, from: response.data)
        }
        return try decoder.decode(JsonRpcResponse<T>.self, from: response.data).result.get()
    }
}