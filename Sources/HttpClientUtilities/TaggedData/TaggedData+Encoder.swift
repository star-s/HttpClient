//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 15.12.2022.
//

import Foundation
import URLEncodedForm

public extension TaggedData {
	static func formURLEncoded<T: Encodable>(
		_ value: T,
		tags: Set<Tag> = [],
		formEncoder: @escaping @autoclosure () -> URLEncodedForm.URLEncodedFormEncoder = URLEncodedForm.URLEncodedFormEncoder()
	) throws -> TaggedData {
		try formEncoder().encode(value).tagged(with: tags.union([.mimeType("application/x-www-form-urlencoded")]))
	}

	static func jsonEncoded<T: Encodable>(
		_ value: T,
		tags: Set<Tag> = [],
		jsonEncoder: @escaping @autoclosure () -> JSONEncoder = JSONEncoder()
	) throws -> TaggedData {
		try jsonEncoder().encode(value).tagged(with: tags.union([.mimeType("application/json")]))
	}
}
