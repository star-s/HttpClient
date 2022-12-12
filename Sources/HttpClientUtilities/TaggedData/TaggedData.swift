//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 12.12.2022.
//

import Foundation
import Combine
import URLEncodedForm

public struct TaggedData {
	public let data: Data
	public let mimeType: String
}

public extension Data {
	func tag(by mimeType: String?) -> TaggedData {
		TaggedData(data: self, mimeType: mimeType ?? "application/octet-stream")
	}

	func tag(by uti: CFString) -> TaggedData {
		tag(by: (UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as NSString?) as String?)
	}
}

extension TaggedData {
	public enum Error: Swift.Error {
		case unsupportedMimeType(String)
	}

	public func decoder<T: Decodable>(
		_ type: T.Type = T.self,
		fallbackToDataDecoder: Bool = true,
		jsonDecoder: @escaping @autoclosure () -> JSONDecoder = JSONDecoder(),
		formDecoder: @escaping @autoclosure () -> URLEncodedFormDecoder = URLEncodedFormDecoder(),
		textDecoder: @escaping @autoclosure () -> PlaintextDecoder = PlaintextDecoder(encoding: .utf8)
	) throws -> TypedDataDecoder<T> {
		switch mimeType.lowercased() {
		case "application/json":
			return TypedDataDecoder(data, decoder: jsonDecoder())
		case "application/x-www-form-urlencoded":
			return TypedDataDecoder(data, decoder: formDecoder())
		case "text/plain":
			return TypedDataDecoder(data, decoder: textDecoder())
		case "application/octet-stream":
			return TypedDataDecoder(data, decoder: DataOnlyDecoder())
		default:
			guard fallbackToDataDecoder else {
				throw Error.unsupportedMimeType(mimeType)
			}
			return TypedDataDecoder(data, decoder: DataOnlyDecoder())
		}
	}
}

extension URLEncodedFormDecoder: TopLevelDecoder {}
