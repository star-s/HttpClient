//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation

public protocol HttpClient: ApplicationLayer {
	
	associatedtype Encoder: RequestEncoder
	var requestEncoder: Encoder { get }

	associatedtype Decoder: ResponseDecoder
	var responseDecoder: Decoder { get }

	associatedtype Transport: TransportLayer
	var transport: Transport { get }
	
	func makeURL(from path: Path) throws -> URL
}

// MARK: - Make URL from Path

public extension HttpClient {
	func makeURL(from path: Path) throws -> URL {
		guard let url = URL(string: String(describing: path)) else {
			throw URLError(.badURL)
		}
		return url
	}
}

public extension HttpClient where Path == URL {
	func makeURL(from path: Path) throws -> URL {
		path
	}
}

// MARK: - ApplicationLayer

public extension HttpClient {
	
	func post<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await requestEncoder.prepare(post: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}
	
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await requestEncoder.prepare(get: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}
	
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await requestEncoder.prepare(put: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}
	
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await requestEncoder.prepare(patch: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}
	
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await requestEncoder.prepare(delete: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}
}
