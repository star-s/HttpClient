//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 17.05.2023.
//

import Foundation

extension TaggedData: Codable {
	public init(from decoder: Decoder) throws {
		let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Type must not be decoded!")
		throw DecodingError.dataCorrupted(context)
	}

	public func encode(to encoder: Encoder) throws {
		let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Type must not be encoded!")
		throw EncodingError.invalidValue("", context)
	}
}
