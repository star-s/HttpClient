//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 28.01.2024.
//

import Foundation
import HttpClient

extension HTTPClientWithBaseURL: ITunesApi {}

struct ITunesClient: HttpClient, ITunesApi {
	struct Path {
		let url: URL?
	}

	let requestEncoder = JsonRequestEncoder()
    let responseDecoder = JSONDecoder().withDefaultResponseValidator()
	let transport = URLSession.shared.withLogger()

	func makeURL(from path: Path) throws -> URL {
		guard let url = path.url else {
			throw URLError(.badURL)
		}
		return url
	}
}

extension ITunesClient.Path: ExpressibleByStringLiteral {
	init(stringLiteral value: String) {
		url = URL(string: value, relativeTo: .iTunesBaseURL)
	}
}
