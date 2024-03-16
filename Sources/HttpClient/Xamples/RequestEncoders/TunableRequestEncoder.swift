//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation

public struct TunableRequestEncoder<E: RequestEncoder>: RequestEncoder {
    let encoder: E
    let tuner: (inout URLRequest) -> Void

    init(_ encoder: E, tuner: @escaping (inout URLRequest) -> Void) {
        self.encoder = encoder
        self.tuner = tuner
    }

    public func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        var request = try await encoder.prepare(post: url, parameters: parameters)
        tuner(&request)
        return request
    }

    public func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
        var request = try await encoder.prepare(get: url, parameters: parameters)
        tuner(&request)
        return request
    }

    public func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        var request = try await encoder.prepare(put: url, parameters: parameters)
        tuner(&request)
        return request
    }

    public func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        var request = try await encoder.prepare(patch: url, parameters: parameters)
        tuner(&request)
        return request
    }

    public func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
        var request = try await encoder.prepare(delete: url, parameters: parameters)
        tuner(&request)
        return request
    }
}
