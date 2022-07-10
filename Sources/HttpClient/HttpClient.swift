//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation

public protocol HttpClient: ApplicationLayer {
	
	associatedtype Presenter: PresentationLayer
	var presenter: Presenter { get }
	
	associatedtype Transport: TransportLayer
	var transport: Transport { get }
	
	func makeURL(from path: Path) throws -> URL
}

public extension HttpClient where Self: PresentationLayer {
	var presenter: Self { self }
}

public extension HttpClient where Self: TransportLayer {
	var transport: Self { self }
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
		let request = try await presenter.prepare(post: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
	
	func get<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await presenter.prepare(get: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
	
	func put<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await presenter.prepare(put: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
	
	func patch<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await presenter.prepare(patch: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
	
	func delete<P: Encodable, T: Decodable>(_ path: Path, parameters: P) async throws -> T {
		let request = try await presenter.prepare(delete: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}
}

// MARK: - Void response

public extension HttpClient {

	func post<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await presenter.prepare(post: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}

	func get<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await presenter.prepare(get: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}

	func put<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await presenter.prepare(put: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}

	func patch<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await presenter.prepare(patch: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}

	func delete<P: Encodable>(_ path: Path, parameters: P) async throws {
		let request = try await presenter.prepare(delete: makeURL(from: path), parameters: parameters)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}
}
