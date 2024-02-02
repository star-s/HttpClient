//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 28.01.2024.
//

import Foundation
import XCTest
@testable import HttpClient

// MARK: - Interface

public protocol ITunesApi {
	func search(_ query: String) async throws -> ITunesSearchResultEntry
}

public struct ITunesSearchResultEntry: Decodable {
	public let results: [ITunesResultEntry]
	public let resultCount: Int
}

public struct ITunesResultEntry: Decodable {
	public let trackName: String
	public let trackId: Int
	public let bundleId: String
	public let trackViewUrl: URL
	public let artworkUrl512: URL
	public let artistName: String
	public let screenshotUrls: [URL]
	public let formattedPrice: String
	public let averageUserRating: Double
}

// MARK: - Abstract implementation

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

// MARK: - Real implementation

extension RelativePathHttpClient: ITunesApi {}

struct ITunecClient: HttpClient, ITunesApi {
	struct Path {
		let url: URL?
	}

	let presenter = JsonPresenter()
	let transport = URLSession.shared.transportWithDefaultLogger()

	func makeURL(from path: Path) throws -> URL {
		guard let url = path.url else {
			throw URLError(.badURL)
		}
		return url
	}
}

extension ITunecClient.Path: ExpressibleByStringLiteral {
	init(stringLiteral value: String) {
		url = URL(string: value, relativeTo: .iTunesBaseURL)
	}
}

// MARK: -

final class ITunesApiTests: XCTestCase {

	func testSearchWithDefaultClient() async throws {
		let client = RelativePathHttpClient(baseURL: .iTunesBaseURL)
		let result = try await client.search("карта")
		XCTAssertFalse(result.results.isEmpty)
	}

	func testSearchWithOwnClient() async throws {
		let client = ITunecClient()
		let result = try await client.search("карта")
		XCTAssertFalse(result.results.isEmpty)
	}
}
