//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import Combine
import HttpClientUtilities
import URLEncodedForm

public protocol CustomRequestEncoder: RequestEncoder {
    var headersFactory: HeadersFactory { get }

	associatedtype QueryEncoder: TopLevelEncoder = URLQueryEncoder where QueryEncoder.Output == String
	var queryEncoder: QueryEncoder { get }

	associatedtype BodyEncoder: TopLevelEncoder = JSONEncoder where BodyEncoder.Output == Data
	var bodyEncoder: BodyEncoder { get }
}

public extension CustomRequestEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
        return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: headersFactory.makeHeaders(for: url, method: .post))
            .with(body: body)
	}

	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
            .with(headers: headersFactory.makeHeaders(for: url, method: .get))
            .with(query: queryEncoder.encode(parameters))
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
		return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: headersFactory.makeHeaders(for: url, method: .put))
            .with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
		return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: headersFactory.makeHeaders(for: url, method: .patch))
            .with(body: body)
	}

	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
            .with(method: .delete)
            .with(headers: headersFactory.makeHeaders(for: url, method: .delete))
            .with(query: queryEncoder.encode(parameters))
	}
}

public extension CustomRequestEncoder where BodyEncoder == JSONEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: headersFactory.makeHeaders(for: url, method: .post))
            .with(body: body)
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: headersFactory.makeHeaders(for: url, method: .put))
            .with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: headersFactory.makeHeaders(for: url, method: .patch))
            .with(body: body)
	}
}

public extension CustomRequestEncoder where BodyEncoder == URLEncodedFormEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .post)
            .with(headers: headersFactory.makeHeaders(for: url, method: .post))
            .with(body: body)
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .put)
            .with(headers: headersFactory.makeHeaders(for: url, method: .put))
            .with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return try await URLRequest(url: url)
            .with(method: .patch)
            .with(headers: headersFactory.makeHeaders(for: url, method: .patch))
            .with(body: body)
	}
}
