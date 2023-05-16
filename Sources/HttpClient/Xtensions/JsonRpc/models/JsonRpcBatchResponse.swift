//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public typealias JsonRpcBatchResponse = Array<Result<JsonRpcBatchResponseElement, JsonRpcError>>

extension Result: Decodable where Success == JsonRpcBatchResponseElement, Failure == JsonRpcError {

	private enum CodingKeys: String, CodingKey {
		case result
		case error
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if container.contains(.result) {
			self = try .success(Success(from: decoder))
		} else {
			self = try .failure(container.decode(Failure.self, forKey: .error))
		}
	}
}

public struct JsonRpcBatchResponseElement {
	public let jsonrpc: JsonRpcVersion
	public let id: String?

	private let resultContainer: KeyedDecodingContainer<CodingKeys>

	public func result<T: Decodable>(_ type: T.Type = T.self) throws -> T {
		try resultContainer.decode(type, forKey: .result)
	}
}

extension JsonRpcBatchResponseElement: Decodable {

	private enum CodingKeys: String, CodingKey {
		case jsonrpc
		case result
		case id
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.jsonrpc = try container.decode(JsonRpcVersion.self, forKey: .jsonrpc)
		self.id = try container.decode(String?.self, forKey: .id)
		self.resultContainer = container
	}
}
