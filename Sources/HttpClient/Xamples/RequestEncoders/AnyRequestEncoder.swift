//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.03.2024.
//

import Foundation

public struct AnyRequestEncoder: RequestEncoder {
    private let encoder: RequestEncoder

    public init(_ encoder: RequestEncoder) {
        self.encoder = encoder
    }

    public func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        try await encoder.prepare(post: url, parameters: parameters)
    }

    public func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
        try await encoder.prepare(get: url, parameters: parameters)
    }

    public func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        try await encoder.prepare(put: url, parameters: parameters)
    }

    public func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        try await encoder.prepare(patch: url, parameters: parameters)
    }

    public func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
        try await encoder.prepare(delete: url, parameters: parameters)
    }
}
