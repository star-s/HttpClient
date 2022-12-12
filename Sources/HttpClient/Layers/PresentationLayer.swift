//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import CoreServices
@_exported import HttpClientUtilities

public protocol PresentationLayer {
    
    func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest
    func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest
    
	func validate(response: (data: Data, response: URLResponse)) async throws
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T

	var jsonDecoder: JSONDecoder { get }
}

public extension PresentationLayer {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .post)
			.with(body: parameters, coder: JSONEncoder(), contentType: "application/json")
	}
	
	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(query: parameters, coder: URLEncodedFormEncoder())
	}
	
	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .put)
			.with(body: parameters, coder: JSONEncoder(), contentType: "application/json")
	}
	
	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .patch)
			.with(body: parameters, coder: JSONEncoder(), contentType: "application/json")
	}
	
	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try URLRequest(url: url)
			.with(headers: .default)
			.with(method: .delete)
			.with(query: parameters, coder: URLEncodedFormEncoder())
	}
	
	func validate(response: (data: Data, response: URLResponse)) async throws {}
	
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		if T.self is RawResponse.Type {
			return RawResponse(rawValue: response.data) as! T
		}
		let textDecoder = PlaintextDecoder(encoding: response.response.textEncoding ?? .ascii)
		return try response
			.data
			.tag(by: response.response.mimeType)
			.decoder(jsonDecoder: jsonDecoder, textDecoder: textDecoder)
			.decode()
	}

	var jsonDecoder: JSONDecoder {
		JSONDecoder()
	}
}
