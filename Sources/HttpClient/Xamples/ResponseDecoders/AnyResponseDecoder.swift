//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public struct AnyResponseDecoder: ResponseDecoder {
    private let decoder: ResponseDecoder

    public init(_ decoder: ResponseDecoder) {
        self.decoder = decoder
    }

    public func validate(response: (data: Data, response: URLResponse)) async throws {
        try await decoder.validate(response: response)
    }
    
    public func decode<T>(response: (data: Data, response: URLResponse)) async throws -> T where T : Decodable {
        try await decoder.decode(response: response)
    }
}
