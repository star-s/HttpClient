//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol JsonRpcService: ApplicationLayer, ApplicationLayerWithoutReturnValue {
	var endpoint: Path { get }

	func invoke<E: Encodable, D: Decodable>(method: String, params: E) async throws -> D
	func notify<E: Encodable>(method: String, params: E) async throws
}

public extension JsonRpcService {
	func invoke<E: Encodable, D: Decodable>(method: String, params: E) async throws -> D {
		try await post(endpoint, parameters: JsonRpcRequest(method: method, params: params, id: .null))
	}

	func notify<E: Encodable>(method: String, params: E) async throws {
		try await post(endpoint, parameters: JsonRpcRequest(method: method, params: params))
	}

	func performBatch(requests: [JsonRpcRequest]) async throws -> [JsonRpcResponse<AnyDecodable>] {
		try await post(endpoint, parameters: requests)
	}
}
