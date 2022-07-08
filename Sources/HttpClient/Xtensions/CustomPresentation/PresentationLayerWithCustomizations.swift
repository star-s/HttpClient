//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation

public protocol PresentationLayerWithCustomizations: PresentationLayer {
	var headers: HTTPHeaders { get }
	var jsonEncoder: JSONEncoder { get }

	func encodeQuery<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest
	func encodeBody<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest
}

public extension PresentationLayerWithCustomizations {

	var headers: HTTPHeaders {
		.default
	}

	var jsonEncoder: JSONEncoder {
		JSONEncoder()
	}

	func encodeQuery<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest {
		try request.with(query: parameters, coder: URLEncodedFormEncoder())
	}

	func encodeBody<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest {
		try request.with(body: parameters, coder: jsonEncoder, contentType: "application/json")
	}

	// MARK: - PresentationLayer

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try encodeBody(request: URLRequest(url: url).with(headers: headers).with(method: .post), parameters: parameters)
	}
	
	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		try encodeQuery(request: URLRequest(url: url).with(headers: headers), parameters: parameters)
	}
	
	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		try encodeBody(request: URLRequest(url: url).with(headers: headers).with(method: .put), parameters: parameters)
	}
	
	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		try encodeBody(request: URLRequest(url: url).with(headers: headers).with(method: .patch), parameters: parameters)
	}
	
	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		try encodeQuery(request: URLRequest(url: url).with(headers: headers).with(method: .delete), parameters: parameters)
	}
}
