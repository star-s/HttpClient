//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 25.09.2021.
//

import Foundation

extension JSONDecoder {
	private static let prefix = Data("{\"value\":".utf8)
	private static let suffix = Data("}".utf8)
	private static let null = Data("null".utf8)

	private static func wrapped(data: Data) -> Data {
		prefix + (data.isEmpty ? null : data) + suffix
	}
	
	private struct Box<T: Decodable>: Decodable {
		let value: T
	}
	
	/// Decodes a value with wrapping with {}, basic types like String, Int, Date... can be decoded.
	///
	/// - parameter type: The type of the value to decode.
	/// - parameter data: The data to decode from.
	/// - returns: A value of the requested type.
	/// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
	public func decodeWithWrapping<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		try decode(Box<T>.self, from: Self.wrapped(data: data)).value
	}
}
