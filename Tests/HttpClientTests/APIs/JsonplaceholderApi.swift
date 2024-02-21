//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 03.02.2022.
//

import Foundation
import HttpClient
import HttpClientUtilities

// MARK: - Interface

public protocol JsonplaceholderApi {
	func fetchPost(number: Int) async throws -> JsonplaceholderPost
	func fetchTodo(number: Int) async throws -> JsonplaceholderTodo
}

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

public extension URL {
	static let jsonplaceholderBaseURL: URL = "https://jsonplaceholder.typicode.com"
}

// MARK: - Implementation

public extension JsonplaceholderApi where Self: ApplicationLayer, Path: ExpressibleByStringInterpolation, Path.StringInterpolation == DefaultStringInterpolation {

	func fetchPost(number: Int) async throws -> JsonplaceholderPost {
		try await get("/posts/\(number)", parameters: Parameters.void)
	}

	func fetchTodo(number: Int) async throws -> JsonplaceholderTodo {
		try await get("/todos/\(number)", parameters: Parameters.void)
	}
}
