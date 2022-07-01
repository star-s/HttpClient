//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation

public struct NullValue {}

extension NullValue: Decodable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		guard container.decodeNil() else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
		}
	}
}

extension NullValue: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}

extension NullValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {}
}
