//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.02.2024.
//

import Foundation
import XCTest
import HttpClient

// https://raw.githubusercontent.com/open-rpc/examples/master/service-descriptions/petstore-openrpc.json

protocol PetstoreApi {
	func listPets(limit: Int) async throws -> [Pet]
	func createPet(name: String, tag: String?) async throws -> Int
	func getPet(id: Int) async throws -> Pet
}

struct Pet: Decodable {
	let id: Int
	let name: String
	let tag: String?
}

// MARK: -

extension PetstoreApi where Self: JsonRpcService {
	func listPets(limit: Int) async throws -> [Pet] {
		try await invoke(method: "list_pets", params: [limit], id: .null)
	}

	func createPet(name: String, tag: String?) async throws -> Int {
		try await invoke(method: "create_pet", params: CreatePetRequest(newPetName: name, newPetTag: tag), id: .null)
	}

	func getPet(id: Int) async throws -> Pet {
		try await invoke(method: "get_pet", params: ["petId": id], id: .null)
	}
}

struct CreatePetRequest: Encodable {
	let newPetName: String
	let newPetTag: String?
}

extension OpenRpc: PetstoreApi {}

final class PetstoreTests: XCTestCase {

	let openRpcApi: OpenRpcApi = OpenRpcMock()

	func testListPets() async throws {
		let result = try await openRpcApi.bootstrapPetstore().listPets(limit: 20)
		XCTAssertFalse(result.isEmpty)
	}

	func testCreatePet() async throws {
		let id = try await openRpcApi.bootstrapPetstore().createPet(name: "fluffy", tag: "poodle")
		XCTAssertFalse(id == 0)
	}

	func testGetPet() async throws {
		let result = try await openRpcApi.bootstrapPetstore().getPet(id: 7)
		XCTAssert(result.id == 7)
	}
}
