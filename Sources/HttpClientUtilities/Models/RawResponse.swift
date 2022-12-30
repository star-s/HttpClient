//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 08.10.2021.
//

import Foundation

public struct RawResponse {
	public let data: Data
	public let response: URLResponse

	public init(data: Data, response: URLResponse) {
		self.data = data
		self.response = response
	}
}

extension RawResponse: Decodable {
	public init(from decoder: Decoder) throws {
		fatalError("Must not be decoded!")
	}
}
