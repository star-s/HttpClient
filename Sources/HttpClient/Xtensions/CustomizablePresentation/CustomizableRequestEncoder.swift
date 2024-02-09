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

public protocol CustomizableRequestEncoder: RequestEncoder {
	associatedtype QueryEncoder: TopLevelEncoder where QueryEncoder.Output == String
	var queryEncoder: QueryEncoder { get }

	associatedtype BodyEncoder: TopLevelEncoder where BodyEncoder.Output == Data
	var bodyEncoder: BodyEncoder { get }
}

public extension CustomizableRequestEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
		return URLRequest(url: url).with(method: .post).with(body: body)
	}

	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url).with(query: queryEncoder.encode(parameters))
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
		return URLRequest(url: url).with(method: .put).with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? bodyEncoder.encode(parameters).tagged(with: [])
		return URLRequest(url: url).with(method: .patch).with(body: body)
	}

	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url).with(method: .delete).with(query: queryEncoder.encode(parameters))
	}
}

public extension CustomizableRequestEncoder where BodyEncoder == JSONEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .post).with(body: body)
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .put).with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		let body = try (parameters as? TaggedData) ?? .jsonEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .patch).with(body: body)
	}
}

public extension CustomizableRequestEncoder where BodyEncoder == URLEncodedFormEncoder {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .post).with(body: body)
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .put).with(body: body)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
        let body = try (parameters as? TaggedData) ?? .formURLEncoded(parameters, encoder: bodyEncoder)
		return URLRequest(url: url).with(method: .patch).with(body: body)
	}
}
