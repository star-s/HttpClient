//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 14.12.2022.
//

import Foundation
import URLEncodedForm

extension TaggedData {
	public enum Error: Swift.Error {
		case noMimeType
		case unknownMimeType(String)
	}

	public enum Fallback<T: Decodable> {
		case throwError
		case decodeAsText
		case decodeAsData
		case custom((TaggedData) throws -> TypedDataDecoder<T>)
	}

	public func decoder<T: Decodable>(
		_ type: T.Type = T.self,
		fallback: Fallback<T> = .throwError,
		jsonDecoder: @escaping @autoclosure () -> JSONDecoder = JSONDecoder(),
		formDecoder: @escaping @autoclosure () -> URLEncodedFormDecoder = URLEncodedFormDecoder()
	) throws -> TypedDataDecoder<T> {
		switch mimeType {
		case "application/json":
			return TypedDataDecoder(data, decoder: jsonDecoder())
		case "application/x-www-form-urlencoded":
			return TypedDataDecoder(data, decoder: formDecoder())
		case "text/plain":
			return TypedDataDecoder(data, decoder: PlaintextDecoder(encoding: textEncoding ?? .ascii))
		case "application/octet-stream":
			return TypedDataDecoder(data, decoder: DataOnlyDecoder())
		case .some(let mimeType):
			if case .throwError = fallback { throw Error.unknownMimeType(mimeType) }
		case .none:
			if case .throwError = fallback { throw Error.noMimeType }
		}
		switch fallback {
		case .throwError:
			fatalError("must throw error early")
		case .decodeAsText:
			return TypedDataDecoder(data, decoder: PlaintextDecoder(encoding: textEncoding ?? .utf8))
		case .decodeAsData:
			return TypedDataDecoder(data, decoder: DataOnlyDecoder())
		case .custom(let closure):
			return try closure(self)
		}
	}
}
