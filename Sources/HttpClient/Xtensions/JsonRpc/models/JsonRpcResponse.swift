//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcResponce<T: Decodable> {
	public let jsonrpc: JsonRpcVersion
	public let result: T
	public let id: String?
}

extension JsonRpcResponce: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case jsonrpc
		case result
		case error
		case id
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		guard container.contains(.result) else {
			throw try container.decode(JsonRpcError.self, forKey: .error)
		}
		self.jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
		self.result = try container.decode(T.self, forKey: .result)
		self.id = try container.decode(String?.self, forKey: .id)
	}
}
