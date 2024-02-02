//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public struct JsonRpcResponce<T> {
	public let jsonrpc: JsonRpcVersion
	public let result: T
	public let id: JsonRpcId

	public init(jsonrpc: JsonRpcVersion = .v2_0, result: T, id: JsonRpcId = nil) {
		self.jsonrpc = jsonrpc
		self.result = result
		self.id = id
	}
}

extension JsonRpcResponce: Decodable where T: Decodable {
	
	private enum DecodingKeys: String, CodingKey {
		case jsonrpc
		case result
		case error
		case id
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: DecodingKeys.self)

		guard container.contains(.result) else {
			throw try container.decode(JsonRpcError.self, forKey: .error)
		}
		self.jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
		self.result = try container.decode(T.self, forKey: .result)
		self.id = try container.decode(JsonRpcId.self, forKey: .id)
	}
}

extension JsonRpcResponce: Encodable where T: Encodable {}
