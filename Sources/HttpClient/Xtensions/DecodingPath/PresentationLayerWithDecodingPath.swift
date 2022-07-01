//
//  File 3.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import CoreServices

public protocol PresentationLayerWithDecodingPath: PresentationLayer {
	func decode<T: Decodable>(response: (data: Data, response: URLResponse), decodingPath: [DecodingKey]?) async throws -> T
}

public extension PresentationLayerWithDecodingPath {
	
	func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		try await decode(response: response, decodingPath: nil)
	}

	func decode<T: Decodable>(response: (data: Data, response: URLResponse), decodingPath: [DecodingKey]?) async throws -> T {
		if (decodingPath ?? []).isEmpty {
			return try await Super().decode(response: response)
		}
		guard let uti = response.response.contentUTI, UTTypeConformsTo(uti, kUTTypeJSON) else {
			throw URLError(.cannotDecodeContentData)
		}
		let coder = jsonDecoder
		coder.valueDecodingPath = decodingPath
		return try coder.decode(DecodingPathAdapter<T>.self, from: response.data).payload
	}
}

private struct Super: PresentationLayer {}
