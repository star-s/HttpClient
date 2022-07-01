import Foundation

/// Decodes data as plaintext.
/// Based on https://github.com/vapor/vapor/blob/main/Sources/Vapor/Content/PlaintextDecoder.swift
public struct PlaintextDecoder {

	public let encoding: String.Encoding

    public init(encoding: String.Encoding) {
		self.encoding = encoding
	}

	public func decode(_ type: Data.Type, from data: Data) throws -> Data {
		data
	}

	public func decode(_ type: URL.Type, from data: Data) throws -> URL {
		guard let string = String(data: data, encoding: encoding) else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Can't make string with encoding \(encoding)"))
		}
		guard let url = URL(string: string) else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Bad string \(string)"))
		}
		return url
	}

	public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		try T(from: _PlaintextDecoder(plaintext: String(data: data, encoding: encoding)))
	}
}

import Combine

extension PlaintextDecoder: TopLevelDecoder {}

// MARK: - Private

private final class _PlaintextDecoder: Decoder {

    let codingPath: [CodingKey] = []
	let userInfo: [CodingUserInfoKey: Any] = [:]
    let plaintext: String?

    init(plaintext: String?) {
        self.plaintext = plaintext
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        throw DecodingError.typeMismatch(type, DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Plaintext decoding does not support dictionaries."
        ))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw DecodingError.typeMismatch(String.self, DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Plaintext decoding does not support arrays."
        ))
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        DataDecodingContainer(decoder: self)
    }
}

private final class DataDecodingContainer: SingleValueDecodingContainer {

    var codingPath: [CodingKey] {
		decoder.codingPath
	}

    let decoder: _PlaintextDecoder
	
    init(decoder: _PlaintextDecoder) {
        self.decoder = decoder
    }

    func decodeNil() -> Bool {
        if let plaintext = decoder.plaintext {
            return plaintext.isEmpty
        }
        return true
    }

    func losslessDecode<L: LosslessStringConvertible>(_ type: L.Type) throws -> L {
        if let plaintext = decoder.plaintext, let decoded = L(plaintext) {
            return decoded
        }
        throw DecodingError.dataCorruptedError(
            in: self,
            debugDescription: "Failed to get \(type) from \"\(decoder.plaintext ?? "")\""
        )
    }

    func decode(_ type: Bool.Type) throws -> Bool {
		try losslessDecode(type)
	}

    func decode(_ type: String.Type) throws -> String {
		if let string = decoder.plaintext {
			return string
		}
		let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Text is nil")
		throw DecodingError.valueNotFound(type, context)
	}

    func decode(_ type: Double.Type) throws -> Double { try losslessDecode(type) }
    func decode(_ type: Float.Type) throws -> Float { try losslessDecode(type) }
    func decode(_ type: Int.Type) throws -> Int { try losslessDecode(type) }
    func decode(_ type: Int8.Type) throws -> Int8 { try losslessDecode(type) }
    func decode(_ type: Int16.Type) throws -> Int16 { try losslessDecode(type) }
    func decode(_ type: Int32.Type) throws -> Int32 { try losslessDecode(type) }
    func decode(_ type: Int64.Type) throws -> Int64 { try losslessDecode(type) }
    func decode(_ type: UInt.Type) throws -> UInt { try losslessDecode(type) }
    func decode(_ type: UInt8.Type) throws -> UInt8 { try losslessDecode(type) }
    func decode(_ type: UInt16.Type) throws -> UInt16 { try losslessDecode(type) }
    func decode(_ type: UInt32.Type) throws -> UInt32 { try losslessDecode(type) }
    func decode(_ type: UInt64.Type) throws -> UInt64 { try losslessDecode(type) }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        throw DecodingError.typeMismatch(type, DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Plaintext decoding does not support nested types."
        ))
    }
}
