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

	func headers() async throws -> HTTPHeaders
	func encodeQuery<T: Encodable>(parameters: T) async throws -> String?
	func encodeBody<T: Encodable>(parameters: T) async throws -> TaggedData
}

public extension PresentationLayerWithCustomizations {

	var jsonEncoder: JSONEncoder {
		JSONEncoder()
	}

	var jsonDecoder: JSONDecoder {
		JSONDecoder()
	}

	func headers() async throws -> HTTPHeaders {
		.default
	}

	func encodeQuery<T: Encodable>(parameters: T) throws -> String? {
		try URLQueryEncoder().encode(parameters)
	}

	func encodeBody<T: Encodable>(parameters: T) throws -> TaggedData {
		try .jsonEncoded(parameters, jsonEncoder: jsonEncoder)
	}

	// MARK: - PresentationLayer

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headers())
			.with(method: .post)
			.with(body: encodeBody(parameters: parameters))
	}
	
	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headers())
			.with(query: encodeQuery(parameters: parameters))
	}
	
	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headers())
			.with(method: .put)
			.with(body: encodeBody(parameters: parameters))
	}
	
	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headers())
			.with(method: .patch)
			.with(body: encodeBody(parameters: parameters))
	}
	
	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headers())
			.with(method: .delete)
			.with(query: encodeQuery(parameters: parameters))
	}

	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		try response
			.data
			.tagged(with: response.response.tags)
			.decoder(fallback: .decodeAsText, jsonDecoder: jsonDecoder)
			.decode()
	}
}
