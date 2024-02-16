//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcError {
	public let code: Int
	public let message: String

	private let dataContainer: KeyedDecodingContainer<CodingKeys>

	public func data<T: Decodable>(_ type: T.Type = T.self) throws -> T {
		try dataContainer.decode(type, forKey: .data)
	}
}

extension JsonRpcError: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case code
		case message
		case data
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.code = try container.decode(Int.self, forKey: .code)
		self.message = try container.decode(String.self, forKey: .message)
		self.dataContainer = container
	}
}

extension JsonRpcError: LocalizedError {
	public var errorDescription: String? { message }
}
