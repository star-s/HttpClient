//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation
import XCTest
import HttpClient
import HttpClientUtilities

protocol OpenRpcApi {
	func bootstrap(_ document: OpenRpcDocument) async throws -> String
}

extension OpenRpcApi {
	func bootstrapSimpleRpc() async throws -> SimpleRpcApi {
		try await OpenRpc(endpoint: bootstrap(.simpleRpc))
	}

	func bootstrapPetstore() async throws -> PetstoreApi {
		try await OpenRpc(endpoint: bootstrap(.petstore))
	}
}

// MARK: -

extension OpenRpcApi where Self: JsonRpcService {
	func bootstrap(_ document: OpenRpcDocument) async throws -> String {
		try await invoke(method: "mock", params: document)
	}
}

extension OpenRpc: OpenRpcApi {}

// MARK: - Tests

class JsonRpcTestCase: XCTestCase {
	let openRpcApi: OpenRpcApi = {
		let transport = TransportMock {
			try $0.handleJsonRpcRequest(OpenRpcDocument.self) {
				switch $0.info.title {
					case "Simple RPC overview":
						return "simpleRpcOverview-2.0.0"
					case "Petstore":
						return "petstore-1.0.0"
					default:
						throw URLError(.cannotDecodeContentData)
				}
			}
		}.withLogger()
		return OpenRpc(transport: transport, endpoint: "/")
	}()
}

private extension URLRequest {
	private struct JsonRpcRequest<T: Decodable>: Decodable {
		let method: String
		let params: T
		let id: JsonRpcId?
	}

	func handleJsonRpcRequest<P: Decodable, T: Encodable>(_ type: P.Type = P.self, _ handler: (P) throws -> T) throws -> (data: Data, response: URLResponse) {
		guard let url, let httpBody else {
			throw URLError(.cannotDecodeContentData)
		}
		let request = try JSONDecoder().decode(JsonRpcRequest<P>.self, from: httpBody)

		let result = try handler(request.params)

		let responseData = try TaggedData.jsonEncoded(
            JsonRpcResponse(result: .success(result), id: request.id ?? .null)
		)
		let response = HTTPURLResponse(
			url: url,
			mimeType: responseData.mimeType,
			expectedContentLength: responseData.data.count,
			textEncodingName: responseData.textEncoding?.IANACharSetName
		)
		return (data: responseData.data, response: response)
	}
}

extension JsonRpcResponse: Encodable where T: Encodable {
    private enum CodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(result.get(), forKey: .result)
        try container.encode(id, forKey: .id)
    }
}
