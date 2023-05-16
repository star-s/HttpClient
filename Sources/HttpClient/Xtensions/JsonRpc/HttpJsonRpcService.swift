//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 16.05.2023.
//

import Foundation

public protocol HttpJsonRpcService: JsonRpcService {
	associatedtype Path

	var endpoint: Path { get }
}

public extension HttpJsonRpcService where Self: ApplicationLayer {

	func invoke<T: Decodable>(request: JsonRpcRequest) async throws -> JsonRpcResponce<T> {
		try await post(endpoint, parameters: request)
	}

	func performBatch(requests: [JsonRpcRequest]) async throws -> JsonRpcBatchResponse {
		try await post(endpoint, parameters: requests)
	}
}

public extension HttpJsonRpcService where Self: ApplicationLayerWithoutReturnValue {

	func notify(request: JsonRpcRequest) async throws {
		try await post(endpoint, parameters: request)
	}
}
