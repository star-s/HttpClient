//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 11.12.2022.
//

import Foundation

/// https://www.rfc-editor.org/rfc/rfc6749#section-7.1
public struct AccessTokenType: RawRepresentable, ExpressibleByStringLiteral, Hashable, Decodable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public init(stringLiteral value: String) {
		self.rawValue = value
	}
}

public extension AccessTokenType {
	static let bearer = AccessTokenType(rawValue: "bearer")
	static let mac = AccessTokenType(rawValue: "mac")
}
