//
//  URL.swift
//
//
//  Created by Sergey Starukhin on 18/09/2019.
//

import Foundation

extension URL {
    public func appendingQuery(_ query: String, percentEncoded: Bool = true) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
			throw URLError(.badURL)
        }
        if percentEncoded {
            components.percentEncodedQuery = query
        } else {
            components.query = query
        }
        guard let result = components.url else {
			throw URLError(.badURL)
        }
        return result
    }
}
