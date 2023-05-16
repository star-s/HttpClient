//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol JsonRpcService {
	func invoke<T: Decodable>(request: JsonRpcRequest) async throws -> JsonRpcResponce<T>
	func notify(request: JsonRpcRequest) async throws
	func performBatch(requests: [JsonRpcRequest]) async throws -> JsonRpcBatchResponse
}

public extension JsonRpcService {
	func invoke<E: Encodable, D: Decodable>(method: String, params: E, id: String? = nil) async throws -> D {
		try await invoke(request: JsonRpcRequest(method: method, params: params, id: id)).result
	}

	func notify<E: Encodable>(method: String, params: E) async throws {
		try await notify(request: JsonRpcRequest(method: method, params: params))
	}
}
