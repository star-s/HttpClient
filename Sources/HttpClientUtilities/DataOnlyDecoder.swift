//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.07.2022.
//

import Foundation

public struct DataOnlyDecoder {

	public init() { }

	public func decode(_ type: Data.Type, from data: Data) throws -> Data {
		data
	}

	public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
		throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: [], debugDescription: "Unsupported data type - \(type)"))
	}
}

import Combine

extension DataOnlyDecoder: TopLevelDecoder {}
