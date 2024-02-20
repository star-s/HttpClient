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
    private let validator: (URLResponse) throws -> Void

	private let jsonDecoder: JSONDecoder
	private let	formDecoder: URLEncodedFormDecoder

	public init<R: RangeExpression>(
        validStatusCodes: R = 200...299,
		jsonDecoder: JSONDecoder = JSONDecoder(),
		formDecoder: URLEncodedFormDecoder = URLEncodedFormDecoder()
    ) where R.Bound == Int {
        self.validator = {
            try $0.checkStatusCode(validRange: validStatusCodes)
        }
		self.jsonDecoder = jsonDecoder
		self.formDecoder = formDecoder
	}

	public func validate(response: (data: Data, response: URLResponse)) async throws {
        try validator(response.response)
    }

	public func decode<T: Decodable>(response: (data: Data, response: URLResponse)) async throws -> T {
		let data = response.data.tagged(with: response.response.tags)
		if T.self is TaggedData.Type {
			return data as! T
		}
		return try data.decoder(
            fallback: .decodeAsText,
            jsonDecoder: jsonDecoder,
            formDecoder: formDecoder
        ).decode()
	}
}
