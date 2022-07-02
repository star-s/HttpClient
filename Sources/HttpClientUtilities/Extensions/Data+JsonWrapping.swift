//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 25.09.2021.
//

import Foundation

extension Data {
	private static let suffix = Data("}".utf8)
	private static let null = Data("null".utf8)

	/// Wraps value in JSON object like {"key": self}, basic types like String, Int, Date... can be decoded.
	///
	/// - parameter key: The key of the json value.
	/// - returns: A valid JSON object in Data form.
	public func wrappedToJson<K: CodingKey>(with key: K) -> Data {
		Data("{\"\(key.stringValue)\":".utf8) + (isEmpty ? Data.null : self) + Data.suffix
	}
}

extension JSONDecoder {

	private struct Box<T: Decodable>: Decodable {
		enum CodingKeys: String, CodingKey {
			case value
		}
		let value: T
	}

	/// Decodes a value with wrapping with {}, basic types like String, Int, Date... can be decoded.
	///
	/// - parameter type: The type of the value to decode.
	/// - parameter data: The data to decode from.
	/// - returns: A value of the requested type.
	/// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
	public func decodeWithWrapping<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		try decode(Box<T>.self, from: data.wrappedToJson(with: Box<T>.CodingKeys.value)).value
	}
}
