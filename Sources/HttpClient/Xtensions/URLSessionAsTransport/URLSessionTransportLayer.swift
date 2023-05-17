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

public extension URLSessionTransportLayer where Self: TransportLayerWithLogging {
	
	var logger: TransportLogger {
		#if DEBUG
		return DefaultLogger(sessionConfiguration: urlSession.configuration)
		#else
		return NullLogger()
		#endif
	}

	func perform(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
		let logger = self.logger
		logger.log(request: request)
		do {
			let response = try await urlSession.perform(request)
			logger.log(result: .success(response))
			return response
		} catch {
			logger.log(result: .failure(error))
			throw error
		}
	}
}
