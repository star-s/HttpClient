//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClient

public protocol JsonplaceholderApi: HttpClientWithBaseUrl where Path: PathExpressibleByInterpolation {
}

public extension JsonplaceholderApi {
	var baseURL: URL { "https://jsonplaceholder.typicode.com" }
}

// MARK: - Public API

public struct JsonplaceholderPost: Decodable {
	public let userId: Int
	public let id: Int
	public let title: String
	public let body: String
}

public struct JsonplaceholderTodo: Decodable {
	public let userId: Int
	public let id: Int
	public let title: String
	public let completed: Bool
}

public extension JsonplaceholderApi {
	func fetchPost(number: Int) async throws -> JsonplaceholderPost {
		try await get("/posts/\(number)", parameters: Parameters.void)
	}
	
	func fetchTodo(number: Int) async throws -> JsonplaceholderTodo {
		try await get("/todos/\(number)", parameters: Parameters.void)
	}
}
