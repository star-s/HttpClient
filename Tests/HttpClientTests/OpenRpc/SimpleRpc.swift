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

// https://raw.githubusercontent.com/open-rpc/examples/master/service-descriptions/api-with-examples-openrpc.json

protocol SimpleRpcApi {
	func getVersions() async throws -> Versions
	func getVersionDetails() async throws -> String
}

struct Versions: Decodable {
	let versions: [OpenRpcDocument.Method.Example.Result.Value.Version]
}

extension SimpleRpcApi where Self: JsonRpcService {

	func getVersions() async throws -> Versions {
		try await invoke(method: "get_versions", params: Parameters.voidArray, id: nil)
	}

	func getVersionDetails() async throws -> String {
		try await invoke(method: "get_version_details", params: Parameters.voidArray, id: nil)
	}
}

// MARK: -

extension OpenRpc: SimpleRpcApi {}

// MARK: -

final class SimpleRpcTests: XCTestCase {

	let openRpcApi: OpenRpcApi = OpenRpcMock()

	func testGetVersions() async throws {
		let result = try await openRpcApi.bootstrapSimpleRpc().getVersions()
		XCTAssertFalse(result.versions.isEmpty)
	}

	func testGetVersionDetails() async throws {
		let details = try await openRpcApi.bootstrapSimpleRpc().getVersionDetails()
		XCTAssertFalse(details.isEmpty)
	}
}
