//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 18.02.2022.
//

import Foundation
import HttpClientUtilities

public protocol HttpClientWithMultipartFormData: HttpClient where Encoder: RequestEncoderWithMultipartFormData {
	func upload<T: Decodable>(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> T
	func upload(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws
}

public extension HttpClientWithMultipartFormData {
	
	func upload<T: Decodable>(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws -> T {
		let request = try await requestEncoder.prepare(post: makeURL(from: path), multipartFormData: multipartFormData)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
		return try await responseDecoder.decode(response: response)
	}

	func upload(_ path: Path, multipartFormData: @escaping (FormDataBuilder) -> Void) async throws {
		let request = try await requestEncoder.prepare(post: makeURL(from: path), multipartFormData: multipartFormData)
		let response = try await transport.perform(request)
		try await responseDecoder.validate(response: response)
	}
}
