//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 28.01.2024.
//

import Foundation

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
