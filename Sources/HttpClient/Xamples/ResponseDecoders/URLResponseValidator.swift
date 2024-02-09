//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation

public extension ResponseDecoder {
    func withResponseValidator(_ validator: @escaping (URLResponse) throws -> Void) -> URLResponseValidator<Self> {
        URLResponseValidator(responseDecoder: self, validator)
    }

    func withDefaultResponseValidator() -> URLResponseValidator<Self> {
        URLResponseValidator(responseDecoder: self) {
            try $0.checkStatusCode(validRange: 200...299)
        }
    }
}

public struct URLResponseValidator<D: ResponseDecoder>: ResponseDecoder {
    private let responseDecoder: D
    private let validator: (URLResponse) throws -> Void

    init(responseDecoder: D, _ validator: @escaping (URLResponse) throws -> Void) {
        self.responseDecoder = responseDecoder
        self.validator = validator
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        try validator(response.response)
    }

    public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
        try await responseDecoder.decode(response: response)
    }
}
