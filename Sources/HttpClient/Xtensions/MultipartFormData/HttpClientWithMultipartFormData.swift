//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.02.2022.
//

import Foundation

public protocol HttpClientWithMultipartFormData: HttpClient where Presenter: PresentationLayerWithMultipartFormData {
	func upload<T: Decodable>(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> T
	func upload(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws
}

public extension HttpClientWithMultipartFormData {
	
	func upload<T: Decodable>(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> T {
		let request = try await presenter.prepare(post: makeURL(from: path), multipartFormData: multipartFormData)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
		return try await presenter.decode(response: response)
	}

	func upload(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws {
		let request = try await presenter.prepare(post: makeURL(from: path), multipartFormData: multipartFormData)
		let response = try await transport.perform(request)
		try await presenter.validate(response: response)
	}
}
