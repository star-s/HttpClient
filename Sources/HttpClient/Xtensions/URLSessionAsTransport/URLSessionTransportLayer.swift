//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 04.04.2021.
//

import Foundation
import HttpClientUtilities

public protocol URLSessionTransportLayer: TransportLayer {
    var session: URLSession { get }
	var loggerFactory: TransportLoggerFactory? { get }
}

public extension URLSessionTransportLayer {
	
	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		guard let logger = loggerFactory?.makeLogger() else {
			return try await session.perform(request)
		}
		logger.log(request: request)
		do {
			let response = try await session.perform(request)
			logger.log(result: .success(response))
			return response
		} catch {
			logger.log(result: .failure(error))
			throw error
		}
	}
}
