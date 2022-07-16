//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.07.2022.
//

import Foundation

public struct ExportedCookies: RawRepresentable {
	public let rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

extension ExportedCookies: ExpressibleByStringLiteral {
	public init(stringLiteral value: StaticString) {
		rawValue = value.description
	}
}

extension ExportedCookies {

	public var cookies: [HTTPCookie] {
		guard let data = Data(base64Encoded: rawValue) else {
			return []
		}
		guard let array = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [ [String: Any] ] else {
			return []
		}
		return array.map {
			$0.reduce(into: [:]) { $0[HTTPCookiePropertyKey($1.key)] = $1.value }
		}.compactMap {
			HTTPCookie(properties: $0)
		}
	}

	public static func export(cookies: [HTTPCookie]) -> ExportedCookies {
		let properties = cookies.map(\.properties).compactMap({ $0 })
		guard let data = try? PropertyListSerialization.data(fromPropertyList: properties, format: .binary, options: 0) else {
			return ""
		}
		return ExportedCookies(rawValue: data.base64EncodedString())
	}
}

extension Array where Element: HTTPCookie {
	public func export() -> ExportedCookies {
		.export(cookies: self)
	}
}
