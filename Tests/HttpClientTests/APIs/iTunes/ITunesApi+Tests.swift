//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 28.01.2024.
//

import XCTest
import HttpClient

final class ITunesApiTests: XCTestCase {

	func testSearchWithDefaultClient() async throws {
		let client = HTTPClientWithBaseURL(baseURL: .iTunesBaseURL)
		let result = try await client.search("карта")
		XCTAssertFalse(result.results.isEmpty)
	}

	func testSearchWithOwnClient() async throws {
		let client = ITunesClient()
		let result = try await client.search("карта")
		XCTAssertFalse(result.results.isEmpty)
	}
}
