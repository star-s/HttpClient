//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 06.02.2024.
//

import Foundation
import HttpClientUtilities
import URLEncodedForm

public struct DefaultResponseDecoder: ResponseDecoder {
	private let jsonDecoder: JSONDecoder
	private let	formDecoder: URLEncodedFormDecoder

	public init(
		jsonDecoder: JSONDecoder = JSONDecoder(),
		formDecoder: URLEncodedFormDecoder = URLEncodedFormDecoder()
	) {
		self.jsonDecoder = jsonDecoder
		self.formDecoder = formDecoder
	}

	public func validate(response: (data: Data, response: URLResponse)) async throws {}

	public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		let data = response.data.tagged(with: response.response.tags)
		if T.self is TaggedData.Type {
			return data as! T
		}
		return try data.decoder(fallback: .decodeAsText, jsonDecoder: jsonDecoder, formDecoder: formDecoder).decode()
	}
}
