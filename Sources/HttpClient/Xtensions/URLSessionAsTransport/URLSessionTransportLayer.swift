//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.04.2021.
//

import Foundation

public protocol URLSessionTransportLayer: TransportLayer {
    var urlSession: URLSession { get }
}

public extension URLSessionTransportLayer {
    
    var urlSession: URLSession {
		.shared
	}

	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		try await urlSession.perform(request)
    }
}
