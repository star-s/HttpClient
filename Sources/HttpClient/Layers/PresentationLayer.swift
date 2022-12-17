//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
@_exported import HttpClientUtilities

public protocol PresentationLayer {
    
    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest
    
	func validate(response: (data: Data, response: URLResponse)) async throws
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T
}

public extension PresentationLayer {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .post)
			.with(body: .jsonEncoded(parameters))
	}
	
	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(query: URLQueryEncoder().encode(parameters))
	}
	
	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .put)
			.with(body: .jsonEncoded(parameters))
	}
	
	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .patch)
			.with(body: .jsonEncoded(parameters))
	}
	
	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .delete)
			.with(query: URLQueryEncoder().encode(parameters))
	}
	
	func validate(response: (data: Data, response: URLResponse)) async throws {}
	
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		try response
			.data
			.tagged(with: response.response.tags)
			.decoder(fallback: .decodeAsText)
			.decode()
	}
}
