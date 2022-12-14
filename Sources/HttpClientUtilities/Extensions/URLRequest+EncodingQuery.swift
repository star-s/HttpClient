//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 23.02.2021.
//

import Foundation
import Combine

public extension URLRequest {

    func with<P: Encodable, C: TopLevelEncoder>(query parameters: P, coder: C) throws -> URLRequest where C.Output == String {
		try with(query: coder.encode(parameters))
    }

    func with<P: Encodable, C: TopLevelEncoder>(query parameters: P, coder: C) throws -> URLRequest where C.Output == Data {
        try with(query: String(decoding: coder.encode(parameters), as: Unicode.ASCII.self))
    }

	func with(query: String?) throws -> URLRequest {
		guard let query = query else {
			return self
		}
		if query.isEmpty {
			return self
		}
		var request = self
		request.url = try request.url?.appendingQuery(query)
		return request
	}
}
