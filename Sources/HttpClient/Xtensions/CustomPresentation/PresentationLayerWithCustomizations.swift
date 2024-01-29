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

public protocol PresentationLayerWithCustomizations: PresentationLayer {
	associatedtype BodyEncoder: TopLevelEncoder where BodyEncoder.Output == Data
	var bodyEncoder: BodyEncoder { get }

	var headersFactory: HeadersFactory { get }

	func encodeQuery<T: Encodable>(parameters: T) async throws -> String?
	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData

	func decode<T: Decodable>(data: TaggedData) async throws -> T
}

public extension PresentationLayerWithCustomizations {

	func encodeQuery<T: Encodable>(parameters: T) async throws -> String? {
		try URLQueryEncoder().encode(parameters)
	}

	func decode<T: Decodable>(data: TaggedData) async throws -> T {
		try data.decoder(fallback: .decodeAsText).decode()
	}

	// MARK: - PresentationLayer

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		let body: TaggedData
		if let data = parameters as? TaggedData {
			body = data
		} else {
			body = try await encodeBody(parameters: parameters)
		}
		return try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .post))
			.with(method: .post)
			.with(body: body)
	}
	
	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .get))
			.with(query: encodeQuery(parameters: parameters))
	}
	
	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		let body: TaggedData
		if let data = parameters as? TaggedData {
			body = data
		} else {
			body = try await encodeBody(parameters: parameters)
		}
		return try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .put))
			.with(method: .put)
			.with(body: body)
	}
	
	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		let body: TaggedData
		if let data = parameters as? TaggedData {
			body = data
		} else {
			body = try await encodeBody(parameters: parameters)
		}
		return try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .patch))
			.with(method: .patch)
			.with(body: body)
	}
	
	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .delete))
			.with(method: .delete)
			.with(query: encodeQuery(parameters: parameters))
	}

	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		let data = response.data.tagged(with: response.response.tags)
		if T.self is TaggedData.Type {
			return data as! T
		}
		return try await decode(data: data)
	}
}

public extension PresentationLayerWithCustomizations where BodyEncoder == JSONEncoder {

	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData {
		try .jsonEncoded(parameters, encoder: bodyEncoder)
	}
}

public extension PresentationLayerWithCustomizations where BodyEncoder == URLEncodedFormEncoder {

	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData {
		try .formURLEncoded(parameters, encoder: bodyEncoder)
	}
}
