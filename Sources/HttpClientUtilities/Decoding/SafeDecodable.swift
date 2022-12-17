//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.10.2022.
//

import Foundation

public struct SafeDecodable<T: LosslessStringConvertible>: RawRepresentable {
	public let rawValue: T

	public init(rawValue: T) {
		self.rawValue = rawValue
	}
}

extension SafeDecodable: Equatable where T: Equatable {}
extension SafeDecodable: Hashable where T: Hashable {}
extension SafeDecodable: Encodable where T: Encodable {}

extension SafeDecodable: Decodable where T: Decodable {
	public init(from decoder: Decoder) throws {
		rawValue = try decoder.singleValueContainer().decodeWithFallbackToString()
	}
}

extension SafeDecodable: ExpressibleByIntegerLiteral where T: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: T.IntegerLiteralType) {
		rawValue = T(integerLiteral: value)
	}
}

extension SafeDecodable: ExpressibleByFloatLiteral where T: ExpressibleByFloatLiteral {
	public init(floatLiteral value: T.FloatLiteralType) {
		rawValue = T(floatLiteral: value)
	}
}

extension SafeDecodable: ExpressibleByBooleanLiteral where T: ExpressibleByBooleanLiteral {
	public init(booleanLiteral value: T.BooleanLiteralType) {
		rawValue = T(booleanLiteral: value)
	}
}
