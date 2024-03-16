//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.03.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public extension CustomRequestEncoder {

    var defaultHeaders: HTTPHeaders { .default }
    var requestAuthorizer: RequestAuthorizer? { nil }

    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
        return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
        try await URLRequest(url: url)
            .with(headers: defaultHeaders)
            .with(query: queryEncoder.encode(parameters))
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
        return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
        return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
        try await URLRequest(url: url)
            .with(method: .delete)
            .with(headers: defaultHeaders)
            .with(query: queryEncoder.encode(parameters))
            .authorize(with: requestAuthorizer)
    }
}

public extension CustomRequestEncoder where BodyEncoder == JSONEncoder {

    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }
}

public extension CustomRequestEncoder where BodyEncoder == URLEncodedFormEncoder {

    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }

    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
        return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: defaultHeaders)
            .with(body: body)
            .authorize(with: requestAuthorizer)
    }
}
