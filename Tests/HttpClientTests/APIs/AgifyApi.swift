//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClient

public protocol AgifyApi: HttpClientWithBaseUrl where Path: ExpressibleByStringLiteral {
}

public extension AgifyApi {
	var baseURL: URL { "https://api.agify.io" }
}

// MARK: - Public API

public struct AgifyData: Decodable {
	public let name: String
	public let age: Int
	public let count: Int
}

public extension AgifyApi {
	func getData(name: String) async throws -> AgifyData {
		try await get("/", parameters: ["name" : name])
	}
}
