//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation
import HttpClientUtilities

public protocol OAuth2PresentationLayer: RequestEncoder {
	var headersFactory: HeadersFactory { get }
}

public extension OAuth2PresentationLayer {

	func prepare<T: Encodable>(post url: URL, parameters: T) async throws -> URLRequest {
		try await URLRequest(url: url)
			.with(headers: headersFactory.makeHeaders(for: url, method: .post))
			.with(method: .post)
			.with(body: .formURLEncoded(parameters))
	}

	func prepare<T: Encodable>(get url: URL, parameters: T) async throws -> URLRequest {
		throw URLError(.resourceUnavailable)
	}

	func prepare<T: Encodable>(put url: URL, parameters: T) async throws -> URLRequest {
		throw URLError(.resourceUnavailable)
	}

	func prepare<T: Encodable>(patch url: URL, parameters: T) async throws -> URLRequest {
		throw URLError(.resourceUnavailable)
	}

	func prepare<T: Encodable>(delete url: URL, parameters: T) async throws -> URLRequest {
		throw URLError(.resourceUnavailable)
	}
}
