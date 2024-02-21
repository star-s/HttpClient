//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 07.03.2021.
//

import Foundation

public protocol HttpClientWithBaseURL: HttpClient {
    associatedtype Path = String

	var baseURL: URL { get }
}

public extension HttpClientWithBaseURL {
	
	func makeURL(from path: Path) throws -> URL {
		guard let url = URL(string: String(describing: path), relativeTo: baseURL) else {
			throw URLError(.badURL)
		}
		return url
	}
}
