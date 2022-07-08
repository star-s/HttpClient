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
    
	func validate(response: (data: Data, response: URLResponse)) async throws -> (data: Data, response: URLResponse)
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
	
	func validate(response: (data: Data, response: URLResponse)) async throws -> (data: Data, response: URLResponse) {
		guard let httpResponse = response.response as? HTTPURLResponse else {
			return response
		}
		guard httpResponse.statusCode == 200 else {
			throw httpResponse
		}
		return response
	}
	
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		if T.self is RawResponse.Type {
			return RawResponse(rawValue: response.data) as! T
		}
		let uti = response.response.contentUTI ?? kUTTypeData

		if UTTypeConformsTo(uti, kUTTypeJSON) {
			return try jsonDecoder.decode(T.self, from: response.data)
		}
		if UTTypeConformsTo(uti, kUTTypeText) {
			return try PlaintextDecoder(encoding: response.response.textEncoding ?? .ascii).decode(T.self, from: response.data)
		}
		return try DataOnlyDecoder().decode(T.self, from: response.data)
	}

	var jsonDecoder: JSONDecoder {
		JSONDecoder()
	}
}
