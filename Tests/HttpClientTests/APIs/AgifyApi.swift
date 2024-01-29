//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClient

// MARK: - Interface

public struct AgifyData: Decodable {
	public let name: String
	public let age: Int
	public let count: Int
}

public protocol AgifyApi {
	func getData(name: String) async throws -> AgifyData
}

public extension URL {
	static let agifyBaseURL: URL = "https://api.agify.io"
}

// MARK: - Implementation

public extension AgifyApi where Self: ApplicationLayer, Path: ExpressibleByStringLiteral {

	func getData(name: String) async throws -> AgifyData {
		try await get("/", parameters: ["name" : name])
	}
}
