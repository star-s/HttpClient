//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation
import Combine

public extension TopLevelDecoder where Input == Data {
    func withResponseValidator(
        _ validator: @escaping (URLResponse, Data) async throws -> Void
    ) -> ResponseValidator<Self> {
        ResponseValidator(decoder: self, validator)
    }

    func withDefaultResponseValidator() -> ResponseValidator<Self> {
        ResponseValidator(decoder: self) { response, _ in
            try (response as? HTTPURLResponse)?.checkHttpStatusCode()
        }
    }
}

public struct ResponseValidator<D: TopLevelDecoder>: ResponseDecoder where D.Input == Data {
    private let decoder: D
    private let validator: (URLResponse, Data) async throws -> Void

    init(decoder: D, _ validator: @escaping (URLResponse, Data) async throws -> Void) {
        self.decoder = decoder
        self.validator = validator
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        try await validator(response.response, response.data)
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        if T.self is TaggedData.Type {
            return response.data.tagged(with: response.response.tags) as! T
        }
        return try decoder.decode(T.self, from: response.data)
    }
}
