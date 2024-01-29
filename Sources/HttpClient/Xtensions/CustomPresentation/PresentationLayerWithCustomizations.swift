//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClientUtilities

public protocol PresentationLayerWithCustomizations: PresentationLayer {
	var jsonEncoder: JSONEncoder { get }
	var jsonDecoder: JSONDecoder { get }

	var headersFactory: HeadersFactory { get }

	func encodeQuery<T: Encodable>(parameters: T) async throws -> String?
	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData

	func decode<T: Decodable>(data: TaggedData) async throws -> T
}

public extension PresentationLayerWithCustomizations {

	var jsonEncoder: JSONEncoder {
		JSONEncoder()
	}

	var jsonDecoder: JSONDecoder {
		JSONDecoder()
	}

	func encodeQuery<T: Encodable>(parameters: T) async throws -> String? {
		try URLQueryEncoder().encode(parameters)
	}

	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData {
		try .jsonEncoded(parameters, encoder: jsonEncoder)
	}

	func decode<T: Decodable>(data: TaggedData) async throws -> T {
		try data.decoder(fallback: .decodeAsText, jsonDecoder: jsonDecoder).decode()
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
