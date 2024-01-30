//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClientUtilities

public protocol HttpClientWithDecodingPath: HttpClient where Presenter: PresentationLayerWithDecodingPath {
	
	func post<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T
}

public extension HttpClientWithDecodingPath {
	
	func post<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T {
		let request = try await presenter.prepare(post: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response, decodingPath: decodingPath)
	}
	
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T {
		let request = try await presenter.prepare(get: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response, decodingPath: decodingPath)
	}
	
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T {
		let request = try await presenter.prepare(put: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response, decodingPath: decodingPath)
	}
	
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T {
		let request = try await presenter.prepare(patch: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response, decodingPath: decodingPath)
	}
	
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P, decodingPath: [DecodingKey]?) async throws -> T {
		let request = try await presenter.prepare(delete: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response, decodingPath: decodingPath)
	}
	
	// MARK: -
	
	func post<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		try await post(path, parameters: parameters, decodingPath: nil)
	}
	
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		try await get(path, parameters: parameters, decodingPath: nil)
	}
	
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		try await put(path, parameters: parameters, decodingPath: nil)
	}
	
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		try await patch(path, parameters: parameters, decodingPath: nil)
	}
	
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		try await delete(path, parameters: parameters, decodingPath: nil)
	}
}
