//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol ApplicationLayerWithoutReturnValue {
	associatedtype Path

	func post<P: Encodable>(_ path: Path, parameters: P) async throws
	func get<P: Encodable>(_ path: Path, parameters: P) async throws
	func put<P: Encodable>(_ path: Path, parameters: P) async throws
	func patch<P: Encodable>(_ path: Path, parameters: P) async throws
	func delete<P: Encodable>(_ path: Path, parameters: P) async throws
}

public extension ApplicationLayerWithoutReturnValue where Self: HttpClient {

	func post<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await requestEncoder.prepare(post: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}

	func get<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await requestEncoder.prepare(get: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}

	func put<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await requestEncoder.prepare(put: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}

	func patch<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await requestEncoder.prepare(patch: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}

	func delete<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await requestEncoder.prepare(delete: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}
}
