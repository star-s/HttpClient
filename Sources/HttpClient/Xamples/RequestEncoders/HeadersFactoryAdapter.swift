//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.02.2024.
//

import Foundation
import HttpClientUtilities

public extension RequestEncoder {
    func withUpdatedHeaders(_ headersFactory: HeadersFactory = HTTPHeaders.defaultFactory) -> HeadersFactoryAdapter<Self> {
        HeadersFactoryAdapter(requestEncoder: self, headersFactory: headersFactory)
    }
}

public struct HeadersFactoryAdapter<E: RequestEncoder>: RequestEncoder {
    private let requestEncoder: E
    private let headersFactory: HeadersFactory

    init(requestEncoder: E, headersFactory: HeadersFactory) {
        self.requestEncoder = requestEncoder
        self.headersFactory = headersFactory
    }

    public func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        try await requestEncoder
            .prepare(post: url, parameters: parameters)
            .update(headers: headersFactory.makeHeaders(for: url, method: .post))
    }

    public func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
        try await requestEncoder
            .prepare(get: url, parameters: parameters)
            .update(headers: headersFactory.makeHeaders(for: url, method: .get))
    }

    public func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        try await requestEncoder
            .prepare(put: url, parameters: parameters)
            .update(headers: headersFactory.makeHeaders(for: url, method: .put))
    }

    public func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        try await requestEncoder
            .prepare(patch: url, parameters: parameters)
            .update(headers: headersFactory.makeHeaders(for: url, method: .patch))
    }

    public func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
        try await requestEncoder
            .prepare(delete: url, parameters: parameters)
            .update(headers: headersFactory.makeHeaders(for: url, method: .delete))
    }
}

extension HeadersFactoryAdapter: RequestEncoderWithMultipartFormData where E: RequestEncoderWithMultipartFormData {
    public func prepare(post url: URL, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> URLRequest {
        try await requestEncoder
            .prepare(post: url, multipartFormData: multipartFormData)
            .update(headers: headersFactory.makeHeaders(for: url, method: .post))
    }
}
