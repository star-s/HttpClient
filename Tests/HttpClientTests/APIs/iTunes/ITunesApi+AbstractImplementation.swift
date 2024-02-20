//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 28.01.2024.
//

import Foundation
import HttpClient

public struct ITunesSearchRequest: Encodable {
	public enum EntityType: String, Encodable {
		case software
	}
	public let entity: EntityType
	public let term: String

	public init(entity: EntityType, term: String) {
		self.entity = entity
		self.term = term
	}
}

public extension URL {
	static let iTunesBaseURL: URL = "https://itunes.apple.com"
}

public extension ITunesApi where Self: ApplicationLayer, Path: ExpressibleByStringLiteral {
	func search(_ query: String) async throws -> ITunesSearchResultEntry {
		try await get("/search", parameters: ITunesSearchRequest(entity: .software, term: query))
	}
}
