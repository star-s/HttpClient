//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.10.2022.
//

import Foundation

extension SingleValueDecodingContainer {
	public func decodeWithFallbackToString<T>(_ type: T.Type = T.self) throws -> T where T: LosslessStringConvertible & Decodable {
		do {
			return try decode(type)
		} catch DecodingError.typeMismatch(_, let context) {
			guard let value = (try? decode(String.self)).flatMap(T.init) else {
				throw DecodingError.typeMismatch(type, context)
			}
			return value
		}
	}
}

extension KeyedDecodingContainerProtocol {
	public func decodeWithFallbackToString<T>(_ type: T.Type = T.self, forKey key: Key) throws -> T where T: LosslessStringConvertible & Decodable {
		do {
			return try decode(type, forKey: key)
		} catch DecodingError.typeMismatch(_, let context) {
			guard let value = (try? decode(String.self, forKey: key)).flatMap(T.init) else {
				throw DecodingError.typeMismatch(type, context)
			}
			return value
		}
	}
}
